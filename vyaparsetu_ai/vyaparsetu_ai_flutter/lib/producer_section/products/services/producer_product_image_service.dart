import 'dart:typed_data';

import 'producer_product_service.dart';

abstract class IProductImageFilenameGenerator {
  String generateFilename(String extension);
}

class SecureRandomFilenameGenerator implements IProductImageFilenameGenerator {
  @override
  String generateFilename(String extension) => 'demo.$extension';
}

abstract class IProducerProductImageService {
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List bytes,
    required String contentType,
  });
  Future<void> deleteProductImage(String storagePath);
  Future<String> createSignedImageUrl({
    required String storagePath,
    int expiresInSeconds = 3600,
  });
}

class ProducerProductImageService implements IProducerProductImageService {
  static const String bucketName = 'product-images';
  static const int maxFileSizeBytes = 5242880;
  final IProductImageFilenameGenerator filenameGenerator;

  ProducerProductImageService({
    dynamic client,
    IProductImageFilenameGenerator? filenameGenerator,
  }) : filenameGenerator = filenameGenerator ?? SecureRandomFilenameGenerator();

  static String normalizeMimeType(String contentType) {
    final value = contentType.toLowerCase();
    if (value.contains('jpeg') || value.contains('jpg')) return 'jpg';
    if (value.contains('png')) return 'png';
    if (value.contains('webp')) return 'webp';
    throw const ProductOperationException('Unsupported image type');
  }

  static String canonicalMimeType(String ext) => ext == 'png'
      ? 'image/png'
      : ext == 'webp'
      ? 'image/webp'
      : 'image/jpeg';

  static void validateStoragePath(String storagePath) {
    if (storagePath.trim().isEmpty || storagePath.split('/').length != 3) {
      throw const ProductOperationException('Invalid storage path');
    }
  }

  @override
  Future<String> uploadProductImage({
    required String productId,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ext = normalizeMimeType(contentType);
    final path = 'demo/$productId/${filenameGenerator.generateFilename(ext)}';
    validateStoragePath(path);
    return path;
  }

  @override
  Future<void> deleteProductImage(String storagePath) async {}

  @override
  Future<String> createSignedImageUrl({
    required String storagePath,
    int expiresInSeconds = 3600,
  }) async => 'data:image/png;base64,iVBORw0KGgo=';
}
