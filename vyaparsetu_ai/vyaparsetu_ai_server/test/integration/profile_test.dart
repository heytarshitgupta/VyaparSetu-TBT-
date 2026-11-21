import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';
import 'package:vyaparsetu_ai_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Profile endpoint', (sessionBuilder, endpoints) {
    Future<TestSessionBuilder> newUser() async {
      final session = sessionBuilder.build();
      final user = await const AuthUsers().create(session);
      return sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id.toString(),
          {},
        ),
      );
    }

    test('requires sign-in to read or create a profile', () async {
      await expectLater(
        endpoints.profile.getMine(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.profile.completeOnboarding(
          sessionBuilder,
          displayName: 'Visitor',
          role: MarketplaceRole.buyer,
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('validates names before writing a profile', () async {
      final session = await newUser();
      for (final name in ['  ', List.filled(81, 'a').join()]) {
        await expectLater(
          endpoints.profile.completeOnboarding(
            session,
            displayName: name,
            role: MarketplaceRole.buyer,
          ),
          throwsA(isA<ProfileException>()),
        );
      }
      expect(await endpoints.profile.getMine(session), isNull);
    });

    test('isolates profiles between buyers and producers', () async {
      final buyer = await newUser();
      final producer = await newUser();
      final buyerProfile = await endpoints.profile.completeOnboarding(
        buyer,
        displayName: '  Buyer Name  ',
        role: MarketplaceRole.buyer,
      );
      expect(await endpoints.profile.getMine(producer), isNull);

      final producerProfile = await endpoints.profile.completeOnboarding(
        producer,
        displayName: 'Producer Name',
        role: MarketplaceRole.producer,
      );
      expect(producerProfile.id, isNot(buyerProfile.id));
      expect(producerProfile.authUserId, isNot(buyerProfile.authUserId));
      expect(
        (await endpoints.profile.getMine(buyer))?.displayName,
        'Buyer Name',
      );
      expect(
        (await endpoints.profile.getMine(producer))?.role,
        MarketplaceRole.producer,
      );
    });

    test('retries keep one profile and cannot change its role', () async {
      final session = await newUser();
      final original = await endpoints.profile.completeOnboarding(
        session,
        displayName: 'Original',
        role: MarketplaceRole.buyer,
      );
      final retry = await endpoints.profile.completeOnboarding(
        session,
        displayName: 'Other Name',
        role: MarketplaceRole.buyer,
      );
      expect(retry.id, original.id);
      expect(retry.displayName, 'Original');

      await expectLater(
        endpoints.profile.completeOnboarding(
          session,
          displayName: 'Original',
          role: MarketplaceRole.producer,
        ),
        throwsA(isA<ProfileException>()),
      );
      expect(
        (await endpoints.profile.getMine(session))?.role,
        MarketplaceRole.buyer,
      );
    });
  });
}
