import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../buyer_section/home/widgets/buyer_product_card.dart';
import '../../buyer_section/theme/buyer_colors.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/routes/app_router.dart';
import 'catalog_providers.dart';
import 'trades_screen.dart' show marketplaceError;

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({this.initialQuery = '', super.key});

  final String initialQuery;

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  late final TextEditingController _search = TextEditingController(
    text: widget.initialQuery,
  );
  late String _query = widget.initialQuery;
  String? _category;
  bool _isSearching = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _submitSearch() {
    setState(() {
      _query = _search.text.trim();
      _isSearching = false;
    });
    ref.invalidate(catalogProvider(_query));
  }

  String _categoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'textile':
      case 'textiles':
      case 'handlooms':
        return 'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200';
      case 'spices':
        return 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=200';
      case 'handicraft':
      case 'handicrafts':
        return 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=200';
      case 'food':
      case 'food processing':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=200';
      default:
        return 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=200';
    }
  }

  List<Product> _filterByCategory(List<Product> products) {
    final category = _category;
    if (category == null) return products;
    return products
        .where(
          (product) =>
              (product.category?.toLowerCase() == category.toLowerCase()) ||
              (product.category?.toLowerCase().contains(
                    category.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = BuyerColors.of(context);
    final catalog = ref.watch(catalogProvider(_query));
    final allProducts =
        ref.watch(catalogProvider('')).value ?? const <Product>[];
    final categories = <String>{
      for (final product in allProducts)
        if (product.category?.trim().isNotEmpty == true)
          product.category!.trim(),
    }.toList()..sort();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        foregroundColor: colors.textPrimary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colors.textPrimary,
            semanticLabel: 'Back',
          ),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _query = '';
                _search.clear();
              });
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
        title: _isSearching
            ? TextField(
                controller: _search,
                autofocus: true,
                onSubmitted: (_) => _submitSearch(),
                style: GoogleFonts.inter(
                  color: colors.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: l10n?.searchProducts ?? 'Search products...',
                  hintStyle: GoogleFonts.inter(
                    color: colors.textSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              )
            : Text(
                l10n?.allCategories ?? 'All Categories',
                style: GoogleFonts.inter(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: colors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _query = '';
                  _search.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            tooltip: 'Post requirement',
            icon: Icon(Icons.post_add, color: colors.textPrimary),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.postRequirementRoute),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 80,
              color: colors.background,
              child: ListView(
                children: [
                  _CategoryRailItem(
                    label: l10n?.forYou ?? 'For You',
                    imageUrl: _categoryImage('For You'),
                    selected: _category == null,
                    onTap: () => setState(() => _category = null),
                  ),
                  for (final category in categories)
                    _CategoryRailItem(
                      label: category,
                      imageUrl: _categoryImage(category),
                      selected: _category == category,
                      onTap: () => setState(() => _category = category),
                    ),
                ],
              ),
            ),
            Expanded(
              child: catalog.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          marketplaceError(
                            error,
                            'Could not load the marketplace.',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: _submitSearch,
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (products) {
                  final visible = _filterByCategory(products);
                  if (visible.isEmpty) {
                    return Center(
                      child: Text(
                        l10n?.noProductsFound ?? 'No products found.',
                        style: GoogleFonts.inter(color: colors.textSecondary),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: visible.length,
                    itemBuilder: (context, index) =>
                        BuyerProductCard(product: visible[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRailItem extends StatelessWidget {
  const _CategoryRailItem({
    required this.label,
    required this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BuyerColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? colors.surface : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: selected ? colors.primary : Colors.transparent,
              width: 4,
            ),
            bottom: BorderSide(color: colors.borderLight),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 44,
                  height: 44,
                  color: colors.borderLight,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 44,
                  height: 44,
                  color: colors.borderLight,
                  child: Icon(
                    Icons.category_outlined,
                    size: 20,
                    color: colors.textLight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? colors.primary : colors.textSecondary,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
