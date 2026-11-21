import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/session_provider.dart';

final productPhotoProvider = FutureProvider.autoDispose.family<ByteData?, int>(
  (ref, id) => ref.watch(serverClientProvider).product.getPhoto(productId: id),
);

class ProductPhotoView extends ConsumerWidget {
  const ProductPhotoView({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(productPhotoProvider(productId)).asData?.value;
    if (photo == null) return const SizedBox.shrink();
    return Image.memory(
      Uint8List.sublistView(photo),
      height: 200,
      fit: BoxFit.contain,
      semanticLabel: 'Product photo',
      errorBuilder: (_, _, _) => const Text('Photo unavailable'),
    );
  }
}
