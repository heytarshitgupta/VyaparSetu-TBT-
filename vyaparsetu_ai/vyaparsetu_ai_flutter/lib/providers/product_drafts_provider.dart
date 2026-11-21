import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import 'session_provider.dart';

/// Provides the list of product drafts for the signed-in producer.
final productDraftsProvider =
    AsyncNotifierProvider.autoDispose<ProductDraftsNotifier, List<Product>>(
  ProductDraftsNotifier.new,
);

class ProductDraftsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final authUserId = ref.watch(signedInUserIdProvider);
    if (authUserId == null) return const [];
    final client = ref.watch(serverClientProvider);
    return client.product.listMyDrafts();
  }

  /// Creates a draft and refreshes the draft list.
  Future<Product> createDraft({
    required String name,
    required String description,
  }) async {
    final client = ref.read(serverClientProvider);
    final product = await client.product.createDraft(
      name: name,
      description: description,
    );
    ref.invalidateSelf();
    await future;
    return product;
  }
}
