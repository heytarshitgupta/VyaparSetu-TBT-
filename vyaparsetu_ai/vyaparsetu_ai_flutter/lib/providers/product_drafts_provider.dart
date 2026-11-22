import 'dart:typed_data';

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
    return client.product.listMyProducts();
  }

  Future<void> setPublished(int id, bool publish) async {
    final endpoint = ref.read(serverClientProvider).product;
    if (publish) {
      await endpoint.publish(productId: id);
    } else {
      await endpoint.hide(productId: id);
    }
    ref.invalidateSelf();
  }

  /// Creates a draft and refreshes the draft list.
  Future<Product> createDraft({
    required String name,
    required String description,
    ByteData? photo,
    int? pricePaise,
    String? category,
    String? unit,
  }) async {
    final client = ref.read(serverClientProvider);
    final product = await client.product.createDraft(
      name: name,
      description: description,
      photo: photo,
      pricePaise: pricePaise,
      category: category,
      unit: unit,
    );
    ref.invalidateSelf();
    return product;
  }
}
