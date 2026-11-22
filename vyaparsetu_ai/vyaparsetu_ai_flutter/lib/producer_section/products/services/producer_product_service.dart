import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart' as sp;

import '../../../../client.dart' as app;
import '../models/producer_product.dart';
import '../models/producer_product_draft.dart';
import 'producer_product_image_service.dart';

class ProductAuthException implements Exception {
  final String message;
  const ProductAuthException([this.message = 'Authentication required']);
}

class ProductOperationException implements Exception {
  final String message;
  final dynamic originalError;
  const ProductOperationException(this.message, [this.originalError]);
}

abstract class IProducerProductService {
  Future<List<ProducerProduct>> fetchProducts({ProductStatus? statusFilter});
  Future<ProducerProduct> updateProductStatus({
    required String productId,
    required ProductStatus newStatus,
  });
  Future<void> deleteProduct(String productId);
  Future<ProducerProduct> createDraft(ProducerProductDraft draft);
  Future<ProducerProduct> updateDraft({
    required String productId,
    required ProducerProductDraft draft,
  });
  Future<ProducerProduct> updateProductImages({
    required String productId,
    required List<String> imagePaths,
  });
  IProducerProductImageService? get imageService => null;
}

class ProducerProductService implements IProducerProductService {
  ProducerProductService({
    dynamic client,
    IProducerProductImageService? imageService,
    bool enableImageService = true,
  }) : imageService = enableImageService
           ? (imageService ?? ProducerProductImageService())
           : null;

  @override
  final IProducerProductImageService? imageService;
  dynamic get client => app.client;

  Future<List<sp.Product>> _serverProducts() =>
      app.client.product.listMyProducts();

  @override
  Future<List<ProducerProduct>> fetchProducts({
    ProductStatus? statusFilter,
  }) async {
    final rows = await _serverProducts();
    return rows
        .where(
          (row) =>
              statusFilter == null || _toOldStatus(row.status) == statusFilter,
        )
        .map(_toOldProduct)
        .toList();
  }

  @override
  Future<ProducerProduct> updateProductStatus({
    required String productId,
    required ProductStatus newStatus,
  }) async {
    final id = int.parse(productId);
    final row = newStatus == ProductStatus.active
        ? await app.client.product.publish(productId: id)
        : newStatus == ProductStatus.hidden
        ? await app.client.product.hide(productId: id)
        : await app.client.product.hide(productId: id);
    return _toOldProduct(row);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await app.client.product.deleteDraft(productId: int.parse(productId));
  }

  @override
  Future<ProducerProduct> createDraft(ProducerProductDraft draft) async {
    final row = await app.client.product.createDraft(
      name: draft.name,
      description: draft.description,
      pricePaise: draft.pricePaise,
      category: draft.category,
      unit: draft.unit,
    );
    return _toOldProduct(row);
  }

  @override
  Future<ProducerProduct> updateDraft({
    required String productId,
    required ProducerProductDraft draft,
  }) async {
    final row = await app.client.product.updateDraft(
      productId: int.parse(productId),
      name: draft.name,
      description: draft.description,
      pricePaise: draft.pricePaise,
      category: draft.category,
      unit: draft.unit,
    );
    return _toOldProduct(row);
  }

  @override
  Future<ProducerProduct> updateProductImages({
    required String productId,
    required List<String> imagePaths,
  }) async => throw const ProductOperationException(
    'Photo storage is updated when creating or publishing a product.',
  );

  ProducerProduct _toOldProduct(sp.Product row) => ProducerProduct(
    id: row.id.toString(),
    producerId: row.producerProfileId.toString(),
    name: row.name,
    description: row.description,
    category: row.category ?? '',
    pricePaise: row.pricePaise,
    unit: row.unit,
    status: _toOldStatus(row.status),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  ProductStatus _toOldStatus(sp.ProductStatus status) =>
      status == sp.ProductStatus.published
      ? ProductStatus.active
      : status == sp.ProductStatus.hidden
      ? ProductStatus.hidden
      : ProductStatus.draft;
}
