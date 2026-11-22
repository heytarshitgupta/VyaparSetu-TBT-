import 'producer_product_image_service.dart';

class EnhancementResult {
  const EnhancementResult({
    required this.improvedStoragePath,
    required this.sourceStoragePath,
  });
  final String improvedStoragePath;
  final String sourceStoragePath;
}

abstract class IProductPhotoEnhancementService {
  Future<EnhancementResult> improvePhoto({
    required String productId,
    required String sourceStoragePath,
  });
  Future<void> discardCandidateImage(String candidateStoragePath);
}

class ProducerProductEnhancementService
    implements IProductPhotoEnhancementService {
  ProducerProductEnhancementService({
    dynamic client,
    IProducerProductImageService? imageService,
  });

  @override
  Future<EnhancementResult> improvePhoto({
    required String productId,
    required String sourceStoragePath,
  }) async => EnhancementResult(
    improvedStoragePath: sourceStoragePath,
    sourceStoragePath: sourceStoragePath,
  );

  @override
  Future<void> discardCandidateImage(String candidateStoragePath) async {}
}
