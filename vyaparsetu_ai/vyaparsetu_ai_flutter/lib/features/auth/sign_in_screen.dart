import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../providers/session_provider.dart';
import 'profile_setup_form.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

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
              child: SignInWidget(client: ref.watch(serverClientProvider)),
            ),
          );
        }
        return _AccountPage(key: ValueKey(authUserId));
      },
    );
  }
}

class _AccountPage extends ConsumerStatefulWidget {
  const _AccountPage({super.key});

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
      body: profile.when(
        skipLoadingOnRefresh: false,
        loading: () => const _Loading(),
        error: (_, _) => _Retry(
          message: 'Could not load your profile.',
          onRetry: () => ref.invalidate(accountProfileProvider),
        ),
        data: (value) => _PageContent(
          child: value == null
              ? ProfileSetupForm(
                  onSave: (name, role) async {
                    await ref
                        .read(serverClientProvider)
                        .profile
                        .completeOnboarding(displayName: name, role: role);
                    if (mounted) ref.invalidate(accountProfileProvider);
                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      switch (value.role) {
                        MarketplaceRole.buyer => 'Buyer workspace',
                        MarketplaceRole.producer => 'Producer workspace',
                      },
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Welcome, ${value.displayName}.'),
                  ],
                ),
        ),
      ),
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
