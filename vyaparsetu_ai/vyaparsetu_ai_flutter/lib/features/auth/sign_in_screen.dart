import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../providers/session_provider.dart';
import 'profile_setup_form.dart';
import '../../buyer_section/home/buyer_main_screen.dart';
import '../../producer_section/home/producer_main_screen.dart';

/// The server generates six digit codes that may contain any digit, including
/// zero, while the sign-in widget defaults to allowing only `1-9`. Accepting
/// every digit keeps those codes enterable.
final _otpCodeConfig = VerificationCodeConfig(
  length: 6,
  allowedCharactersPattern: RegExp(r'[0-9]'),
);

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key, this.initialRole});

  final MarketplaceRole? initialRole;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionInitializationProvider);
    return session.when(
      loading: () => const Scaffold(body: _Loading()),
      error: (_, _) => Scaffold(
        body: _Retry(
          message: 'Could not restore your session.',
          onRetry: () => ref.invalidate(sessionInitializationProvider),
        ),
      ),
      data: (_) {
        final authUserId = ref.watch(signedInUserIdProvider);
        if (authUserId == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('VyaparSetu AI')),
            body: _PageContent(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/vyapar_setu_banner.jpg',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SignInWidget(
                    client: ref.watch(serverClientProvider),
                    emailOtpSignInWidget: EmailOtpSignInWidget(
                      client: ref.watch(serverClientProvider),
                      otpVerificationCodeConfig: _otpCodeConfig,
                      verificationCodeConfig: _otpCodeConfig,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return _AccountPage(
          key: ValueKey(authUserId),
          initialRole: initialRole,
        );
      },
    );
  }
}

class _AccountPage extends ConsumerStatefulWidget {
  const _AccountPage({super.key, this.initialRole});
  final MarketplaceRole? initialRole;

  @override
  ConsumerState<_AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<_AccountPage> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    try {
      await ref.read(serverClientProvider).auth.signOutDevice();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not sign out. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountProfileProvider);
    return profile.when(
      skipLoadingOnRefresh: false,
      loading: () => const Scaffold(body: _Loading()),
      error: (_, _) => Scaffold(
        body: _Retry(
          message: 'Could not load your profile.',
          onRetry: () => ref.invalidate(accountProfileProvider),
        ),
      ),
      data: (value) {
        if (value == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('VyaparSetu AI'),
              actions: [
                TextButton(
                  onPressed: _signingOut ? null : _signOut,
                  child: Text(_signingOut ? 'Signing out…' : 'Sign out'),
                ),
              ],
            ),
            body: _PageContent(
              child: ProfileSetupForm(
                initialRole: widget.initialRole,
                onSave: (name, role) async {
                  await ref
                      .read(serverClientProvider)
                      .profile
                      .completeOnboarding(displayName: name, role: role);
                  if (mounted) ref.invalidate(accountProfileProvider);
                },
              ),
            ),
          );
        }
        // The role home screens bring their own Scaffold and navigation bar,
        // so they must not be nested inside the scrollable setup page.
        return value.role == MarketplaceRole.buyer
            ? const BuyerMainScreen()
            : const ProducerMainScreen();
      },
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: child,
        ),
      ),
    ),
  );
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _Retry extends StatelessWidget {
  const _Retry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _PageContent(
    child: Column(
      children: [
        Text(message),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}
