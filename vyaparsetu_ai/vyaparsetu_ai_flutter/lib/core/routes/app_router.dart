import 'package:flutter/material.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../buyer_section/home/buyer_main_screen.dart';
import '../../buyer_section/notifications/notifications_screen.dart';
import '../../buyer_section/post_requirement/post_requirement_screen.dart';
import '../../buyer_section/requirements/my_requirements_screen.dart';
import '../../buyer_section/wishlist/wishlist_screen.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/marketplace/marketplace_screen.dart';
import '../../features/marketplace/trades_screen.dart';
import '../../producer_section/home/producer_main_screen.dart';
import '../../producer_section/onboarding/producer_onboarding_screen.dart';
import '../auth/role_selection_screen.dart';

class AppRouter {
  AppRouter._();

  static const initialRoute = '/';
  static const buyerAuthRoute = '/buyer_auth';
  static const buyerSignupRoute = '/buyer_signup';
  static const buyerForgotPasswordEmailRoute = '/buyer_forgot_password_email';
  static const buyerResetPasswordRoute = '/buyer_reset_password';
  static const buyerSignInEmailRoute = '/buyer_signin_email';
  static const buyerOtpVerificationRoute = '/buyer_otp_verification';
  static const buyerVerifyEmailRoute = '/buyer_verify_email';
  static const otpRoute = '/otp';
  static const buyerOnboardingRoute = '/buyer_onboarding';
  static const buyerVerificationRoute = '/buyer_verification';
  static const buyerCheckSubmitRoute = '/buyer_check_submit';
  static const buyerSuccessRoute = '/buyer_success';
  static const homeRoute = '/home';
  static const marketplaceRoute = '/marketplace';
  static const productDetailRoute = '/product_detail';
  static const postRequirementRoute = '/post_requirement';
  static const myRequestsRoute = '/my_requests';
  static const comparisonRoute = '/comparison';
  static const notificationsRoute = '/notifications';
  static const wishlistRoute = '/wishlist';
  static const orderBargainRoute = '/order_bargain';
  static const sellerDashboardRoute = '/seller_dashboard';
  static const customizationRoute = '/customization';
  static const buyerOrdersRoute = '/buyer_orders';
  static const orderDetailsRoute = '/order_details';
  static const producerLoginRoute = '/producer_login';
  static const producerSignupRoute = '/producer_signup';
  static const producerHomeRoute = '/producer_home';
  static const producerOnboardingRoute = '/producer_onboarding';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final roleBuyer = const SignInScreen(initialRole: MarketplaceRole.buyer);
    final roleProducer = const SignInScreen(
      initialRole: MarketplaceRole.producer,
    );

    switch (settings.name) {
      case initialRoute:
        return _route(settings, const RoleSelectionScreen());
      case buyerAuthRoute:
      case buyerSignupRoute:
      case buyerForgotPasswordEmailRoute:
      case buyerResetPasswordRoute:
      case buyerSignInEmailRoute:
      case buyerOtpVerificationRoute:
      case buyerVerifyEmailRoute:
      case otpRoute:
        return _route(settings, roleBuyer);
      case homeRoute:
      case buyerOnboardingRoute:
      case buyerVerificationRoute:
      case buyerCheckSubmitRoute:
      case buyerSuccessRoute:
        return _route(settings, const BuyerMainScreen());
      case marketplaceRoute:
        return _route(
          settings,
          MarketplaceScreen(
            initialQuery: settings.arguments is String
                ? settings.arguments as String
                : '',
          ),
        );
      case productDetailRoute:
      case comparisonRoute:
      case sellerDashboardRoute:
      case customizationRoute:
        return _route(settings, const MarketplaceScreen());
      case postRequirementRoute:
        return _route(
          settings,
          PostRequirementScreen(
            prefilledCategory: settings.arguments as String?,
          ),
        );
      case myRequestsRoute:
        return _route(settings, const MyRequirementsScreen());
      case buyerOrdersRoute:
      case orderDetailsRoute:
        return _route(
          settings,
          const TradesScreen(role: MarketplaceRole.buyer),
        );
      case notificationsRoute:
        return _route(settings, const NotificationsScreen());
      case wishlistRoute:
        return _route(settings, const BuyerWishlistScreen());
      case orderBargainRoute:
        return _route(
          settings,
          const TradesScreen(role: MarketplaceRole.buyer),
        );
      case producerLoginRoute:
      case producerSignupRoute:
        return _route(settings, roleProducer);
      case producerOnboardingRoute:
        return _route(settings, const ProducerOnboardingScreen());
      case producerHomeRoute:
      default:
        if (settings.name == producerHomeRoute) {
          return _route(settings, const ProducerMainScreen());
        }
        return _route(
          settings,
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _route(
    RouteSettings settings,
    Widget child,
  ) => MaterialPageRoute(settings: settings, builder: (_) => child);
}
