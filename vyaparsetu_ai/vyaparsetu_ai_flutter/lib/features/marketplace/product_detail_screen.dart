import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../buyer_section/theme/buyer_colors.dart';
import '../../providers/session_provider.dart';
import 'product_photo.dart';
import 'trades_screen.dart' show marketplaceError, tradesProvider;

/// Formats an amount stored in paise for display, e.g. 65000 -> ₹650.
String formatRupees(int? paise) {
  if (paise == null) return 'Ask for price';
  final rupees = paise / 100;
  final text = rupees == rupees.roundToDouble()
      ? rupees.toStringAsFixed(0)
      : rupees.toStringAsFixed(2);
  return '₹$text';
}

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.product, super.key});

  final Product product;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final _form = GlobalKey<FormState>();
  final _quantity = TextEditingController(text: '1');
  final _requirements = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _quantity.dispose();
    _requirements.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending || !_form.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref
          .read(serverClientProvider)
          .trade
          .requestQuote(
            productId: widget.product.id!,
            quantity: int.parse(_quantity.text.trim()),
            requirements: _requirements.text,
          );
      if (!mounted) return;
      ref.invalidate(tradesProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quote request sent.')));
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = marketplaceError(error, 'Could not send the request.'),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BuyerColors.of(context);
    final product = widget.product;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: Text(
          product.name,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.borderLight),
                ),
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ProductPhotoView(productId: product.id!),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formatRupees(product.pricePaise),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '/ ${product.unit}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (product.category != null && product.category!.isNotEmpty)
                    _MetaChip(label: product.category!),
                  _MetaChip(label: 'MOQ ${product.minimumOrderQuantity}'),
                  if (product.city != null && product.city!.isNotEmpty)
                    _MetaChip(label: product.city!),
                ],
              ),
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    color: colors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Request a quote',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (text) {
                  final quantity = int.tryParse(text?.trim() ?? '');
                  return quantity == null || quantity < 1 || quantity > 100000
                      ? 'Enter a quantity between 1 and 100,000.'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _requirements,
                decoration: const InputDecoration(
                  labelText: 'Requirements or delivery date',
                ),
                maxLength: 2000,
                maxLines: 3,
              ),
              if (_error != null) ...[
                const SizedBox(height: 4),
                Text(_error!, style: TextStyle(color: colors.badgePinkText)),
              ],
              const SizedBox(height: 8),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: _sending ? null : _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.orangeAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    _sending ? 'Sending…' : 'Request quote',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = BuyerColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderLight),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}
