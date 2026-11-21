import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

class ProductEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Product> createDraft(
    Session session, {
    required String name,
    required String description,
  }) async {
    final producer = await _requireProducer(session);
    final cleanName = name.trim();
    final cleanDescription = description.trim();
    if (cleanName.isEmpty || cleanName.runes.length > 120) {
      throw ProductDraftException(message: 'Enter a name of 1 to 120 characters.');
    }
    if (cleanDescription.runes.length > 2000) {
      throw ProductDraftException(message: 'Use at most 2000 description characters.');
    }

    return Product.db.insertRow(
      session,
      Product(
        producerProfileId: producer.id!,
        name: cleanName,
        description: cleanDescription,
        status: ProductStatus.draft,
      ),
    );
  }

  Future<List<Product>> listMyDrafts(Session session) async {
    final producer = await _requireProducer(session);
    return Product.db.find(
      session,
      where: (product) =>
          product.producerProfileId.equals(producer.id!) &
          product.status.equals(ProductStatus.draft),
      orderBy: (product) => product.id.desc(),
      limit: 50,
    );
  }

  Future<AccountProfile> _requireProducer(Session session) async {
    final authUserId = session.authenticated!.authUserId;
    final profile = await AccountProfile.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
    );
    if (profile == null || profile.role != MarketplaceRole.producer) {
      throw ProductDraftException(message: 'A Producer profile is required.');
    }
    return profile;
  }
}
