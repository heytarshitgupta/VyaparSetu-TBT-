import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../providers/session_provider.dart';

/// Published products from the marketplace catalog, filtered by [query].
final catalogProvider = FutureProvider.autoDispose
    .family<List<Product>, String>(
      (ref, query) =>
          ref.watch(serverClientProvider).product.catalog(query: query),
    );

/// Ids of the products in the signed-in buyer's wishlist.
final wishlistIdsProvider = FutureProvider.autoDispose<Set<int>>((ref) async {
  final rows = await ref
      .watch(serverClientProvider)
      .marketplaceExtra
      .wishlist();
  return rows.map((row) => row.productId).toSet();
});
