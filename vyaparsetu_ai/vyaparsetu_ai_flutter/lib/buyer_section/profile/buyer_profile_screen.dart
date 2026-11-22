import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../theme/buyer_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../onboarding/buyer_profile_provider.dart';
import '../../../producer_section/localization/widgets/language_switcher_widget.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../providers/session_provider.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

class BuyerProfileScreen extends ConsumerWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mockProfile = context.watch<BuyerProfileProvider>().profile;
    final account = ref.watch(accountProfileProvider).value;
    final profile = mockProfile ?? _fromAccount(account);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BuyerColors.of(context).background,
      appBar: AppBar(
        title: Text(
          l10n?.myProfile ?? 'My Account',
          style: GoogleFonts.inter(
            color: BuyerColors.of(context).textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: BuyerColors.of(context).surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black12,
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          children: [
            // User Header
            _buildProfileHeader(context, profile),
            const SizedBox(height: 24),

            // Quick Links
            Text(
              l10n?.quickLinks ?? 'Quick Links',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BuyerColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: BuyerColors.of(context).surface,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: BuyerColors.of(context).borderLight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildListTile(
                      context,
                      Icons.shopping_bag_outlined,
                      l10n?.myOrders ?? 'My Orders',
                      '/buyer_orders',
                      BuyerColors.of(context).primary,
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    _buildListTile(
                      context,
                      Icons.favorite_border,
                      l10n?.wishlist ?? 'Wishlist',
                      '/wishlist',
                      BuyerColors.of(context).orangeAccent,
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    _buildListTile(
                      context,
                      Icons.chat_bubble_outline,
                      l10n?.myRequirements ?? 'My Requirements',
                      '/my_requests',
                      BuyerColors.of(context).badgeGreen,
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    _buildListTile(
                      context,
                      Icons.add_circle_outline,
                      'Post Requirement',
                      '/post_requirement',
                      BuyerColors.of(context).primary,
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    _buildListTile(
                      context,
                      Icons.notifications_outlined,
                      l10n?.notifications ?? 'Notifications',
                      '/notifications',
                      BuyerColors.of(context).orangeAccent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Business Information
            Text(
              l10n?.businessInformation ?? 'Business Information',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BuyerColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BuyerColors.of(context).surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BuyerColors.of(context).borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow(
                    context,
                    Icons.business,
                    l10n?.businessName ?? 'Business Name',
                    (profile != null &&
                            profile.businessName != null &&
                            profile.businessName!.isNotEmpty)
                        ? profile.businessName!
                        : l10n?.notProvided ?? 'Not provided',
                  ),
                  Divider(
                    height: 24,
                    color: BuyerColors.of(context).borderLight,
                  ),
                  _buildInfoRow(
                    context,
                    Icons.category,
                    l10n?.category ?? 'Category',
                    (profile != null &&
                            profile.businessCategory != null &&
                            profile.businessCategory!.isNotEmpty)
                        ? profile.businessCategory!
                        : l10n?.notProvided ?? 'Not provided',
                  ),
                  Divider(
                    height: 24,
                    color: BuyerColors.of(context).borderLight,
                  ),
                  _buildInfoRow(
                    context,
                    Icons.email,
                    l10n?.email ?? 'Email',
                    (profile != null && profile.email.isNotEmpty)
                        ? profile.email
                        : l10n?.notProvided ?? 'Not provided',
                  ),
                  Divider(
                    height: 24,
                    color: BuyerColors.of(context).borderLight,
                  ),
                  _buildInfoRow(
                    context,
                    Icons.phone,
                    l10n?.phone ?? 'Phone',
                    (profile != null && profile.mobile.isNotEmpty)
                        ? profile.mobile
                        : l10n?.notProvided ?? 'Not provided',
                  ),
                  Divider(
                    height: 24,
                    color: BuyerColors.of(context).borderLight,
                  ),
                  _buildInfoRow(
                    context,
                    Icons.location_on,
                    l10n?.address ?? 'Address',
                    (profile != null && profile.address.isNotEmpty)
                        ? '${profile.address}, ${profile.city}, ${profile.state} - ${profile.pincode}'
                        : l10n?.notProvided ?? 'Not provided',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Activity (Mock)
            Text(
              l10n?.recentActivity ?? 'Recent Activity',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BuyerColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: BuyerColors.of(context).surface,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: BuyerColors.of(context).borderLight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActivityTile(
                      context,
                      'Order placed: Handwoven Stoles',
                      '2 days ago',
                      Icons.check_circle_outline,
                      BuyerColors.of(context).badgeGreen,
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    _buildActivityTile(
                      context,
                      'Enquiry sent to Sharma Pottery',
                      '5 days ago',
                      Icons.send_outlined,
                      BuyerColors.of(context).primary,
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    _buildActivityTile(
                      context,
                      'Saved "Organic Spices" product',
                      '1 week ago',
                      Icons.bookmark_outline,
                      BuyerColors.of(context).orangeAccent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Preferences
            Text(
              l10n?.settings ?? 'Preferences',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BuyerColors.of(context).textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: BuyerColors.of(context).surface,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: BuyerColors.of(context).borderLight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.language,
                        color: BuyerColors.of(context).primary,
                      ),
                      title: Text(
                        l10n?.language ?? 'Language',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: BuyerColors.of(context).textPrimary,
                        ),
                      ),
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [LanguageSwitcherWidget(isCompact: true)],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return ListTile(
                          leading: Icon(
                            Icons.dark_mode_outlined,
                            color: BuyerColors.of(context).primary,
                          ),
                          title: Text(
                            l10n?.darkMode ?? 'Dark Mode',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: BuyerColors.of(context).textPrimary,
                            ),
                          ),
                          trailing: Switch(
                            value: themeProvider.isDarkMode(context),
                            onChanged: (val) {
                              themeProvider.setThemeMode(
                                val ? ThemeMode.dark : ThemeMode.light,
                              );
                            },
                            activeColor: BuyerColors.of(context).primary,
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      color: BuyerColors.of(context).borderLight,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications_outlined,
                        color: BuyerColors.of(context).primary,
                      ),
                      title: Text(
                        l10n?.notifications ?? 'Notifications',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: BuyerColors.of(context).textPrimary,
                        ),
                      ),
                      trailing: Switch(
                        value: true,
                        onChanged: (val) {},
                        activeColor: BuyerColors.of(context).primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            const _LogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    Color iconColor,
  ) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: BuyerColors.of(context).textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: BuyerColors.of(context).textSecondary,
      ),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }

  Widget _buildProfileHeader(BuildContext context, BuyerProfile? profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BuyerColors.of(context).primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              (profile?.name.isNotEmpty ?? false)
                  ? profile!.name[0].toUpperCase()
                  : 'B',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: BuyerColors.of(context).primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? 'Guest Buyer',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (profile?.mobile.isNotEmpty ?? false)
                      ? profile!.mobile
                      : (profile?.email.isNotEmpty ?? false)
                      ? profile!.email
                      : (profile?.businessName?.isNotEmpty ?? false)
                      ? profile!.businessName!
                      : 'VyaparSetu Buyer',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BuyerProfile? _fromAccount(AccountProfile? account) {
    if (account == null) return null;
    return BuyerProfile(
      name: account.displayName,
      businessName: account.businessName,
      mobile: '',
      email: '',
      buyerType: 'buyer',
      businessCategory: account.craftCategory,
      address: account.address ?? '',
      city: account.city ?? '',
      state: account.state ?? '',
      pincode: '',
      isBusinessVerified: account.verified,
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: BuyerColors.of(context).textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: BuyerColors.of(context).textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: BuyerColors.of(context).textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, size: 16, color: color),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: BuyerColors.of(context).textPrimary,
        ),
      ),
      subtitle: Text(
        time,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: BuyerColors.of(context).textSecondary,
        ),
      ),
    );
  }
}

class _LogoutButton extends ConsumerStatefulWidget {
  const _LogoutButton();

  @override
  ConsumerState<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends ConsumerState<_LogoutButton> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);
    try {
      await ref.read(serverClientProvider).auth.signOutDevice();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.initialRoute,
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not sign out. Try again.')),
      );
      setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: _signingOut ? null : _signOut,
        style: OutlinedButton.styleFrom(
          foregroundColor: BuyerColors.of(context).badgePinkText,
          side: BorderSide(color: BuyerColors.of(context).badgePinkText),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _signingOut
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                'Log out',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
