import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../features/marketplace/catalog_providers.dart';
import '../../../features/marketplace/product_detail_screen.dart';
import '../../../features/marketplace/product_photo.dart';
import '../../../features/marketplace/trades_screen.dart' show marketplaceError;
import '../../../providers/session_provider.dart';
import '../../theme/buyer_colors.dart';

/// Flipkart-style product tile used on the buyer home dashboard.
class BuyerProductCard extends ConsumerWidget {
  const BuyerProductCard({required this.product, super.key});

  final Product product;

  Future<void> _toggleWishlist(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(serverClientProvider)
          .marketplaceExtra
          .toggleWishlist(productId: product.id!);
      ref.invalidate(wishlistIdsProvider);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            marketplaceError(error, 'Could not update your wishlist.'),
          ),
        ),
      );
    }
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = BuyerColors.of(context);
    final photo = ref.watch(productPhotoProvider(product.id!)).asData?.value;
    final saved = ref.watch(wishlistIdsProvider).value?.contains(product.id);

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ProductImage(photo: photo),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => _toggleWishlist(context, ref),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          saved == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: saved == true
                              ? colors.orangeAccent
                              : colors.textSecondary,
                          semanticLabel: saved == true
                              ? 'Remove from wishlist'
                              : 'Add to wishlist',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category?.isNotEmpty == true
                          ? product.category!
                          : (product.city?.isNotEmpty == true
                                ? product.city!
                                : 'Handmade'),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            formatRupees(product.pricePaise),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'MOQ ${product.minimumOrderQuantity}',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 32,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openDetail(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.orangeAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          l10n?.orderNow ?? 'Order Now',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.photo});

  final ByteData? photo;

  @override
  Widget build(BuildContext context) {
    final colors = BuyerColors.of(context);
    if (photo == null) {
      return Container(
        color: colors.background,
        alignment: Alignment.center,
        child: Icon(
          Icons.inventory_2_outlined,
          size: 34,
          color: colors.textLight,
        ),
      );
    }
    return Image.memory(
      Uint8List.sublistView(photo!),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      semanticLabel: 'Product photo',
      errorBuilder: (_, _, _) => Container(
        color: colors.background,
        alignment: Alignment.center,
        child: Icon(
          Icons.inventory_2_outlined,
          size: 34,
          color: colors.textLight,
        ),
      ),
    );
  }
}
