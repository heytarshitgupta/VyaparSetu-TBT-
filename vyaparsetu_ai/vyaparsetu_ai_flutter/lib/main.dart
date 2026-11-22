import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'client.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/localization/language_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/routes/app_router.dart';
import 'buyer_section/onboarding/buyer_profile_provider.dart';
import 'buyer_section/post_requirement/requests_provider.dart';
import 'buyer_section/wishlist/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: _BuyerProfileProvider.create),
          provider.ChangeNotifierProvider(create: _LanguageProvider.create),
          provider.ChangeNotifierProvider(create: _ThemeProvider.create),
          provider.ChangeNotifierProvider(create: _RequestsProvider.create),
          provider.ChangeNotifierProvider(create: _WishlistProvider.create),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class _BuyerProfileProvider {
  static BuyerProfileProvider create(BuildContext _) => BuyerProfileProvider();
}

class _LanguageProvider {
  static LanguageProvider create(BuildContext _) => LanguageProvider();
}

class _ThemeProvider {
  static ThemeProvider create(BuildContext _) => ThemeProvider();
}

class _RequestsProvider {
  static RequestsProvider create(BuildContext _) => RequestsProvider();
}

class _WishlistProvider {
  static WishlistProvider create(BuildContext _) => WishlistProvider();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = provider.Provider.of<LanguageProvider>(
      context,
      listen: true,
    );
    final themeProvider = provider.Provider.of<ThemeProvider>(
      context,
      listen: true,
    );
    return MaterialApp(
      title: 'VyaparSetu AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: languageProvider.currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
