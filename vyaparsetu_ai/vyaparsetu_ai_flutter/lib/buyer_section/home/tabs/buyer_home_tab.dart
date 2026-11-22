import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routes/app_router.dart';
import '../../../features/marketplace/catalog_providers.dart';
import '../../../features/marketplace/trades_screen.dart' show marketplaceError;
import '../../theme/buyer_colors.dart';
import '../widgets/buyer_product_card.dart';

/// Flipkart-style buyer dashboard: logo bar, search, banner, categories and a
/// two-column product grid backed by the live marketplace catalog.
class BuyerHomeTab extends ConsumerStatefulWidget {
  const BuyerHomeTab({this.onOpenMarketplace, this.onOpenAccount, super.key});

  /// Switches the buyer shell to the Search tab. Falls back to pushing the
  /// marketplace route when the tab is used on its own.
  final VoidCallback? onOpenMarketplace;

  /// Switches the buyer shell to the Account tab.
  final VoidCallback? onOpenAccount;

  @override
  ConsumerState<BuyerHomeTab> createState() => _BuyerHomeTabState();
}

class _BuyerHomeTabState extends ConsumerState<BuyerHomeTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String? _category;

  static const _categories = <_Category>[
    _Category(
      'All Categories',
      'For You',
      'https://images.unsplash.com/photo-1556740758-90de374c12ad?w=200',
    ),
    _Category(
      'Handlooms',
      'Textiles',
      'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=200',
    ),
    _Category(
      'Spices',
      'Spices',
      'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=200',
    ),
    _Category(
      'Handicrafts',
      'Handicrafts',
      'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=200',
    ),
    _Category(
      'Food',
      'Food',
      'https://images.unsplash.com/photo-1542838132-92c53300491e?w=200',
    ),
    _Category(
      'Gifting',
      'Gifting',
      'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=200',
    ),
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  void _openMarketplace() {
    if (widget.onOpenMarketplace != null) {
      widget.onOpenMarketplace!();
      return;
    }
    Navigator.pushNamed(context, AppRouter.marketplaceRoute);
  }

  List<Product> _applyCategory(List<Product> products) {
    final category = _category;
    if (category == null) return products;
    final needle = category.toLowerCase();
    return products
        .where(
          (product) =>
              (product.category?.toLowerCase().contains(needle) ?? false) ||
              product.name.toLowerCase().contains(needle) ||
              product.description.toLowerCase().contains(needle),
        )
        .toList();
  }

  void _showFilterSheet() {
    final l10n = AppLocalizations.of(context);
    final colors = BuyerColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n?.filters ?? 'Filters',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.filterByCategory ?? 'Filter by Category',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in _categories)
                  FilterChip(
                    label: Text(category.filter),
                    selected:
                        (_category == null && category.filter == 'For You') ||
                        _category == category.filter,
                    selectedColor: colors.primary.withValues(alpha: 0.2),
                    checkmarkColor: colors.primary,
                    onSelected: (_) {
                      setState(() {
                        _category = category.filter == 'For You'
                            ? null
                            : category.filter;
                      });
                      Navigator.pop(sheetContext);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(sheetContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n?.close ?? 'Close'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = BuyerColors.of(context);
    final catalog = ref.watch(catalogProvider(_query));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: colors.surface,
          floating: true,
          pinned: false,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 2,
          shadowColor: Colors.black12,
          toolbarHeight: 60,
          title: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(
                  text: 'Vyapar',
                  style: TextStyle(color: colors.primary),
                ),
                TextSpan(
                  text: 'Setu',
                  style: TextStyle(color: colors.orangeAccent),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Notifications',
              icon: Icon(Icons.notifications, color: colors.primary, size: 22),
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.notificationsRoute),
            ),
            IconButton(
              tooltip: 'Account',
              icon: Icon(
                Icons.account_circle,
                color: colors.primary,
                size: 26,
              ),
              onPressed: widget.onOpenAccount ?? _openMarketplace,
            ),
            const SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            color: colors.surface,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderLight),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => setState(() => _query = value.trim()),
                decoration: InputDecoration(
                  hintText:
                      l10n?.searchHint ??
                      'Search for Products, Brands and More',
                  hintStyle: GoogleFonts.inter(
                    color: colors.textSecondary,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Filters',
                    icon: Icon(Icons.tune, color: colors.primary, size: 20),
                    onPressed: _showFilterSheet,
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width - 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/vyapar_setu_banner.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final category in _categories)
                    _CircularCategory(
                      category: category,
                      selected:
                          (_category == null && category.filter == 'For You') ||
                          _category == category.filter,
                      onTap: () => setState(
                        () => _category = category.filter == 'For You'
                            ? null
                            : category.filter,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: colors.surface,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n?.recommendedForYou ?? 'Recommended For You',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: _openMarketplace,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      l10n?.viewAll ?? 'VIEW ALL',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ...catalog.when(
          loading: () => [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
          error: (error, _) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      marketplaceError(
                        error,
                        'Could not load the marketplace.',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(catalogProvider(_query)),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          ],
          data: (products) {
            final visible = _applyCategory(products);
            if (visible.isEmpty) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        l10n?.noProductsFound ?? 'No products found.',
                        style: GoogleFonts.inter(color: colors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ];
            }
            return [
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        BuyerProductCard(product: visible[index]),
                    childCount: visible.length,
                  ),
                ),
              ),
            ];
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 48)),
      ],
    );
  }
}

class _Category {
  const _Category(this.title, this.filter, this.imageUrl);

  final String title;
  final String filter;
  final String imageUrl;
}

class _CircularCategory extends StatelessWidget {
  const _CircularCategory({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final _Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BuyerColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? colors.orangeAccent : colors.borderLight,
                  width: 2,
                ),
                color: colors.background,
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: category.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(color: colors.borderLight),
                errorWidget: (_, _, _) => Icon(
                  Icons.category_outlined,
                  size: 24,
                  color: colors.textLight,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.title,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
