import 'package:flutter/material.dart';
import '../../../core/localization/generated/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/buyer_colors.dart';
import '../profile/buyer_profile_screen.dart';
import '../../../features/marketplace/marketplace_screen.dart';
import '../../../features/marketplace/trades_screen.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';
import 'tabs/buyer_home_tab.dart';

class BuyerMainScreen extends StatefulWidget {
  const BuyerMainScreen({super.key});

  @override
  State<BuyerMainScreen> createState() => _BuyerMainScreenState();
}

class _BuyerMainScreenState extends State<BuyerMainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _tabs = [
    BuyerHomeTab(
      onOpenMarketplace: () => setState(() => _currentIndex = 1),
      onOpenAccount: () => setState(() => _currentIndex = 3),
    ),
    const MarketplaceScreen(),
    const TradesScreen(role: MarketplaceRole.buyer, embedded: true),
    const BuyerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BuyerColors.of(context).background,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: BuyerColors.of(context).surface,
          border: Border(
            top: BorderSide(color: BuyerColors.of(context).border, width: 1),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  0,
                  Icons.grid_view_outlined,
                  Icons.grid_view,
                  l10n?.navDiscover ?? 'Discover',
                ),
                _buildNavItem(
                  1,
                  Icons.search_outlined,
                  Icons.search,
                  l10n?.navSearch ?? 'Search',
                ),
                _buildNavItem(
                  2,
                  Icons.receipt_long_outlined,
                  Icons.receipt_long,
                  l10n?.navOrders ?? 'Orders',
                ),
                _buildNavItem(
                  3,
                  Icons.person_outline,
                  Icons.person,
                  l10n?.navAccount ?? 'Account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? BuyerColors.of(context).primary
                  : BuyerColors.of(context).textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? BuyerColors.of(context).primary
                    : BuyerColors.of(context).textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
