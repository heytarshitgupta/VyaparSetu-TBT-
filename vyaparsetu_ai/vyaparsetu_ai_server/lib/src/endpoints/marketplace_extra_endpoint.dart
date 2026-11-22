import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'profile_endpoint.dart';

class MarketplaceExtraEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<WishlistItem>> wishlist(Session session) async {
    final buyer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.buyer,
    );
    return WishlistItem.db.find(
      session,
      where: (row) => row.buyerProfileId.equals(buyer.id!),
      orderBy: (row) => row.createdAt.desc(),
      limit: 100,
    );
  }

  Future<WishlistItem> toggleWishlist(
    Session session, {
    required int productId,
  }) async {
    final buyer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.buyer,
    );
    final existing = await WishlistItem.db.findFirstRow(
      session,
      where: (row) =>
          row.buyerProfileId.equals(buyer.id!) &
          row.productId.equals(productId),
    );
    if (existing != null) {
      await WishlistItem.db.deleteRow(session, existing);
      return existing;
    }
    return WishlistItem.db.insertRow(
      session,
      WishlistItem(
        buyerProfileId: buyer.id!,
        productId: productId,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<List<BuyerRequirement>> listRequirements(Session session) async {
    final profile = await ProfileEndpoint().getMine(session);
    if (profile == null) {
      throw ProductDraftException(message: 'Complete profile first.');
    }
    if (profile.role == MarketplaceRole.buyer) {
      return BuyerRequirement.db.find(
        session,
        where: (row) => row.buyerProfileId.equals(profile.id!),
        orderBy: (row) => row.createdAt.desc(),
        limit: 100,
      );
    }
    return BuyerRequirement.db.find(
      session,
      where: (row) => row.status.equals('open'),
      orderBy: (row) => row.createdAt.desc(),
      limit: 100,
    );
  }

  Future<BuyerRequirement> createRequirement(
    Session session, {
    required String title,
    required String description,
    required String category,
    required int quantity,
    int? budgetPaise,
    String? city,
    String? state,
  }) async {
    final buyer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.buyer,
    );
    if (title.trim().isEmpty || quantity < 1) {
      throw ProductDraftException(message: 'Enter a title and valid quantity.');
    }
    final requirement = await BuyerRequirement.db.insertRow(
      session,
      BuyerRequirement(
        buyerProfileId: buyer.id!,
        title: title.trim(),
        description: description.trim(),
        category: category.trim(),
        quantity: quantity,
        budgetPaise: budgetPaise,
        city: city?.trim(),
        state: state?.trim(),
        status: 'open',
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await _notifyRole(
      session,
      role: MarketplaceRole.producer,
      title: 'New buyer requirement',
      message: '${requirement.title} - ${requirement.quantity} units',
      type: 'buyer_requirement',
      relatedId: requirement.id,
    );
    return requirement;
  }

  Future<RequirementResponse> respondRequirement(
    Session session, {
    required int requirementId,
    required String message,
    int? quotedPaise,
  }) async {
    final producer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.producer,
    );
    final requirement = await BuyerRequirement.db.findById(
      session,
      requirementId,
    );
    if (requirement == null) {
      throw ProductDraftException(message: 'Requirement unavailable.');
    }
    final response = await RequirementResponse.db.insertRow(
      session,
      RequirementResponse(
        requirementId: requirementId,
        producerProfileId: producer.id!,
        message: message.trim(),
        quotedPaise: quotedPaise,
        status: 'responded',
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await AppNotification.db.insertRow(
      session,
      AppNotification(
        profileId: requirement.buyerProfileId,
        title: 'Producer response',
        message: message.trim().isEmpty
            ? 'A producer responded to your requirement.'
            : message.trim(),
        type: 'requirement_response',
        relatedId: requirementId,
        isRead: false,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    return response;
  }

  Future<List<AppNotification>> notifications(Session session) async {
    final profile = await ProfileEndpoint().getMine(session);
    if (profile == null) return [];
    return AppNotification.db.find(
      session,
      where: (row) => row.profileId.equals(profile.id!),
      orderBy: (row) => row.createdAt.desc(),
      limit: 100,
    );
  }

  Future<AppNotification> markNotificationRead(
    Session session, {
    required int notificationId,
  }) async {
    final profile = await ProfileEndpoint().getMine(session);
    if (profile == null) {
      throw ProductDraftException(message: 'Complete profile first.');
    }
    final rows = await AppNotification.db.updateWhere(
      session,
      where: (row) =>
          row.id.equals(notificationId) & row.profileId.equals(profile.id!),
      columnValues: (row) => [row.isRead(true)],
    );
    if (rows.isEmpty) {
      throw ProductDraftException(message: 'Notification unavailable.');
    }
    return rows.single;
  }

  Future<Map<String, int>> sellerStats(Session session) async {
    final producer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.producer,
    );
    final products = await Product.db.find(
      session,
      where: (row) => row.producerProfileId.equals(producer.id!),
    );
    final trades = await TradeRequest.db.find(
      session,
      where: (row) => row.producerProfileId.equals(producer.id!),
    );
    final requirements = await BuyerRequirement.db.count(session);
    return {
      'products': products.length,
      'published': products
          .where((row) => row.status == ProductStatus.published)
          .length,
      'requests': trades.length,
      'accepted': trades
          .where((row) => row.status == TradeStatus.accepted)
          .length,
      'marketRequirements': requirements,
    };
  }

  Future<void> _notifyRole(
    Session session, {
    required MarketplaceRole role,
    required String title,
    required String message,
    required String type,
    int? relatedId,
  }) async {
    final profiles = await AccountProfile.db.find(
      session,
      where: (row) => row.role.equals(role),
      limit: 100,
    );
    for (final profile in profiles) {
      await AppNotification.db.insertRow(
        session,
        AppNotification(
          profileId: profile.id!,
          title: title,
          message: message,
          type: type,
          relatedId: relatedId,
          isRead: false,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }
  }
}
