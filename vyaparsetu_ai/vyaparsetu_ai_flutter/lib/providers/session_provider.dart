import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../client.dart';

final serverClientProvider = Provider<Client>((ref) => client);

final sessionInitializationProvider = FutureProvider<void>((ref) async {
  await ref.watch(serverClientProvider).auth.initialize();
});

final signedInUserIdProvider = NotifierProvider<SignedInUserId, String?>(
  SignedInUserId.new,
);

class SignedInUserId extends Notifier<String?> {
  @override
  String? build() {
    final authInfo = ref.watch(serverClientProvider).auth.authInfoListenable;
    void update() => state = authInfo.value?.authUserId.toString();

    authInfo.addListener(update);
    ref.onDispose(() => authInfo.removeListener(update));
    return authInfo.value?.authUserId.toString();
  }
}

final accountProfileProvider = FutureProvider.autoDispose<AccountProfile?>((
  ref,
) async {
  if (ref.watch(signedInUserIdProvider) == null) return null;
  return ref.watch(serverClientProvider).profile.getMine();
});
