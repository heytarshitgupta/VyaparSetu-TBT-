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
  dynamic get client => null;
  @override
  final IProducerProductImageService? imageService;
  static final List<ProducerProduct> _products = [];

  ProducerProductService({
    dynamic client,
    IProducerProductImageService? imageService,
    bool enableImageService = true,
  }) : imageService = enableImageService
           ? (imageService ?? ProducerProductImageService())
           : null;

  @override
  Future<List<ProducerProduct>> fetchProducts({
    ProductStatus? statusFilter,
  }) async => statusFilter == null
      ? List.unmodifiable(_products)
      : _products.where((p) => p.status == statusFilter).toList();

  @override
  Future<ProducerProduct> updateProductStatus({
    required String productId,
    required ProductStatus newStatus,
  }) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index < 0) throw const ProductOperationException('Product not found');
    final old = _products[index];
    final updated = ProducerProduct(
      id: old.id,
      producerId: old.producerId,
      name: old.name,
      description: old.description,
      category: old.category,
      pricePaise: old.pricePaise,
      unit: old.unit,
      images: old.images,
      status: newStatus,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
    );
    _products[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
  }

  @override
  Future<ProducerProduct> createDraft(ProducerProductDraft draft) async {
    final now = DateTime.now();
    final product = ProducerProduct(
      id: 'demo-${_products.length + 1}',
      producerId: 'demo-producer',
      name: draft.name,
      description: draft.description,
      category: draft.category,
      pricePaise: draft.pricePaise,
      unit: draft.unit,
      images: draft.images,
      status: ProductStatus.draft,
      createdAt: now,
      updatedAt: now,
    );
    _products.insert(0, product);
    return product;
  }

  @override
  Future<ProducerProduct> updateDraft({
    required String productId,
    required ProducerProductDraft draft,
  }) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index < 0) throw const ProductOperationException('Product not found');
    final old = _products[index];
    final updated = ProducerProduct(
      id: old.id,
      producerId: old.producerId,
      name: draft.name,
      description: draft.description,
      category: draft.category,
      pricePaise: draft.pricePaise,
      unit: draft.unit,
      images: draft.images,
      status: old.status,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
    );
    _products[index] = updated;
    return updated;
  }

  @override
  Future<ProducerProduct> updateProductImages({
    required String productId,
    required List<String> imagePaths,
  }) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index < 0) throw const ProductOperationException('Product not found');
    final old = _products[index];
    final updated = ProducerProduct(
      id: old.id,
      producerId: old.producerId,
      name: old.name,
      description: old.description,
      category: old.category,
      pricePaise: old.pricePaise,
      unit: old.unit,
      images: imagePaths,
      status: old.status,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
    );
    _products[index] = updated;
    return updated;
  }
}
