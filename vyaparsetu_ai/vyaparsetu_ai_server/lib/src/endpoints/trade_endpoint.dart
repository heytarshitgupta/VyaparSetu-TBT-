import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'profile_endpoint.dart';

class TradeEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<TradeRequest>> listMine(Session session) async {
    final profile = await ProfileEndpoint().getMine(session);
    if (profile == null) {
      throw ProductDraftException(message: 'Complete your profile first.');
    }
    return TradeRequest.db.find(
      session,
      where: (row) => profile.role == MarketplaceRole.buyer
          ? row.buyerProfileId.equals(profile.id!)
          : row.producerProfileId.equals(profile.id!),
      orderBy: (row) => row.id.desc(),
      limit: 100,
    );
  }

  Future<TradeRequest> requestQuote(
    Session session, {
    required int productId,
    required int quantity,
    required String requirements,
  }) async {
    final buyer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.buyer,
    );
    final note = requirements.trim();
    if (quantity < 1 || quantity > 100000 || note.runes.length > 2000) {
      throw ProductDraftException(
        message:
            'Enter a quantity from 1 to 100,000 and up to 2,000 characters.',
      );
    }
    final product = await Product.db.findFirstRow(
      session,
      where: (row) =>
          row.id.equals(productId) & row.status.equals(ProductStatus.published),
    );
    if (product == null) {
      throw ProductDraftException(message: 'This product is unavailable.');
    }
    return TradeRequest.db.insertRow(
      session,
      TradeRequest(
        productId: product.id!,
        buyerProfileId: buyer.id!,
        producerProfileId: product.producerProfileId,
        productName: product.name,
        quantity: quantity,
        requirements: note,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<TradeRequest> quote(
    Session session, {
    required int requestId,
    required int totalPaise,
  }) async {
    final producer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.producer,
    );
    if (totalPaise < 1 || totalPaise > 10000000000) {
      throw ProductDraftException(message: 'Enter a valid quote amount.');
    }
    final rows = await TradeRequest.db.updateWhere(
      session,
      where: (row) =>
          row.id.equals(requestId) &
          row.producerProfileId.equals(producer.id!) &
          row.status.equals(TradeStatus.requested),
      columnValues: (row) => [
        row.status(TradeStatus.quoted),
        row.totalPaise(totalPaise),
      ],
    );
    return _updated(rows);
  }

  Future<TradeRequest> accept(Session session, {required int requestId}) async {
    final buyer = await requireMarketplaceProfile(
      session,
      MarketplaceRole.buyer,
    );
    final rows = await TradeRequest.db.updateWhere(
      session,
      where: (row) =>
          row.id.equals(requestId) &
          row.buyerProfileId.equals(buyer.id!) &
          row.status.equals(TradeStatus.quoted),
      columnValues: (row) => [row.status(TradeStatus.accepted)],
    );
    if (rows.isNotEmpty) return rows.single;
    final accepted = await TradeRequest.db.findFirstRow(
      session,
      where: (row) =>
          row.id.equals(requestId) &
          row.buyerProfileId.equals(buyer.id!) &
          row.status.equals(TradeStatus.accepted),
    );
    if (accepted != null) return accepted;
    return _updated(rows);
  }

  TradeRequest _updated(List<TradeRequest> rows) {
    if (rows.isEmpty) {
      throw ProductDraftException(
        message: 'This request is unavailable for that action.',
      );
    }
    return rows.single;
  }
}
