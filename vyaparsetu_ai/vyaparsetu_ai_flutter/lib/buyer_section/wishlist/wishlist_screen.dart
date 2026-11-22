import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/session_provider.dart';

final _wishlistProvider = FutureProvider.autoDispose((ref) async {
  final client = ref.watch(serverClientProvider);
  final rows = await client.marketplaceExtra.wishlist();
  final catalog = await client.product.catalog(query: '');
  final ids = rows.map((row) => row.productId).toSet();
  return catalog.where((product) => ids.contains(product.id)).toList();
});

class BuyerWishlistScreen extends ConsumerWidget {
  const BuyerWishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(_wishlistProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: wishlist.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(_wishlistProvider),
            child: const Text('Retry wishlist'),
          ),
        ),
        data: (products) => products.isEmpty
            ? const Center(child: Text('Your wishlist is empty'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: product.description.isEmpty
                          ? null
                          : Text(product.description),
                      trailing: IconButton(
                        tooltip: 'Remove',
                        icon: const Icon(Icons.favorite),
                        onPressed: () async {
                          await ref
                              .read(serverClientProvider)
                              .marketplaceExtra
                              .toggleWishlist(productId: product.id!);
                          ref.invalidate(_wishlistProvider);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
