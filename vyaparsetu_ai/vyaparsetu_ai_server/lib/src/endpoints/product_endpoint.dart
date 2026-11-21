import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'profile_endpoint.dart';

class ProductEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Product> createDraft(
    Session session, {
    required String name,
    required String description,
    ByteData? photo,
  }) async {
    final producer = await _requireProducer(session);
    final cleanName = name.trim();
    final cleanDescription = description.trim();
    if (cleanName.isEmpty || cleanName.runes.length > 120) {
      throw ProductDraftException(
        message: 'Enter a name of 1 to 120 characters.',
      );
    }
    if (cleanDescription.runes.length > 2000) {
      throw ProductDraftException(
        message: 'Use at most 2000 description characters.',
      );
    }

    if (photo != null && !_validPhoto(photo)) {
      throw ProductDraftException(message: 'Use a JPEG or PNG up to 240 KB.');
    }
    final draft = Product(
      producerProfileId: producer.id!,
      name: cleanName,
      description: cleanDescription,
      status: ProductStatus.draft,
    );
    if (photo == null) return Product.db.insertRow(session, draft);
    return session.db.transaction((transaction) async {
      final saved = await Product.db.insertRow(
        session,
        draft,
        transaction: transaction,
      );
      await ProductPhoto.db.insertRow(
        session,
        ProductPhoto(productId: saved.id!, bytes: photo),
        transaction: transaction,
      );
      return saved;
    });
  }

  Future<ByteData?> getPhoto(Session session, {required int productId}) async {
    final profile = await ProfileEndpoint().getMine(session);
    if (profile == null) return null;
    final product = await Product.db.findFirstRow(
      session,
      where: (row) =>
          row.id.equals(productId) &
          (profile.role == MarketplaceRole.producer
              ? row.producerProfileId.equals(profile.id!)
              : row.status.equals(ProductStatus.published)),
    );
    if (product == null) return null;
    final photo = await ProductPhoto.db.findFirstRow(
      session,
      where: (row) => row.productId.equals(productId),
    );
    return photo?.bytes;
  }

  bool _validPhoto(ByteData photo) {
    if (photo.lengthInBytes < 8 || photo.lengthInBytes > 240 * 1024) {
      return false;
    }
    return photo.getUint16(0) == 0xffd8 ||
        (photo.getUint32(0) == 0x89504e47 && photo.getUint32(4) == 0x0d0a1a0a);
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

  Future<List<Product>> listMyProducts(Session session) async {
    final producer = await _requireProducer(session);
    return Product.db.find(
      session,
      where: (product) => product.producerProfileId.equals(producer.id!),
      orderBy: (product) => product.id.desc(),
      limit: 100,
    );
  }

  Future<List<Product>> catalog(
    Session session, {
    required String query,
  }) async {
    await requireMarketplaceProfile(session, MarketplaceRole.buyer);
    final search = query.trim();
    if (search.runes.length > 120) {
      throw ProductDraftException(
        message: 'Use at most 120 search characters.',
      );
    }
    final escaped = search.replaceAllMapped(
      RegExp(r'[\\%_]'),
      (match) => '\\${match[0]}',
    );
    final pattern = '%$escaped%';
    return Product.db.find(
      session,
      where: (product) =>
          product.status.equals(ProductStatus.published) &
          (product.name.ilike(pattern) | product.description.ilike(pattern)),
      orderBy: (product) => product.id.desc(),
      limit: 100,
    );
  }

  Future<Product> publish(Session session, {required int productId}) =>
      _changeStatus(session, productId, ProductStatus.published);

  Future<Product> hide(Session session, {required int productId}) =>
      _changeStatus(session, productId, ProductStatus.hidden);

  Future<Product> _changeStatus(
    Session session,
    int productId,
    ProductStatus status,
  ) async {
    final producer = await _requireProducer(session);
    final updated = await Product.db.updateWhere(
      session,
      columnValues: (product) => [product.status(status)],
      where: (product) {
        final owned =
            product.id.equals(productId) &
            product.producerProfileId.equals(producer.id!);
        return status == ProductStatus.hidden
            ? owned & product.status.notEquals(ProductStatus.draft)
            : owned;
      },
    );
    if (updated.isEmpty) {
      throw ProductDraftException(
        message: 'This product is unavailable for that action.',
      );
    }
    return updated.single;
  }

  Future<AccountProfile> _requireProducer(Session session) =>
      requireMarketplaceProfile(session, MarketplaceRole.producer);
}
