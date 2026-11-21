import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';
import 'package:vyaparsetu_ai_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Product endpoint', (sessionBuilder, endpoints) {
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

    Future<TestSessionBuilder> newProducer({String name = 'Test Producer'}) async {
      final session = await newUser();
      await endpoints.profile.completeOnboarding(
        session,
        displayName: name,
        role: MarketplaceRole.producer,
      );
      return session;
    }

    Future<TestSessionBuilder> newBuyer({String name = 'Test Buyer'}) async {
      final session = await newUser();
      await endpoints.profile.completeOnboarding(
        session,
        displayName: name,
        role: MarketplaceRole.buyer,
      );
      return session;
    }

    test('denies access when signed out', () async {
      await expectLater(
        endpoints.product.createDraft(
          sessionBuilder,
          name: 'Draft',
          description: 'Description',
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );

      await expectLater(
        endpoints.product.listMyDrafts(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('denies access to buyers and un-onboarded users', () async {
      final buyerSession = await newBuyer();
      await expectLater(
        endpoints.product.createDraft(
          buyerSession,
          name: 'Buyer Item',
          description: 'Should fail',
        ),
        throwsA(
          isA<ProductDraftException>().having(
            (e) => e.message,
            'message',
            'A Producer profile is required.',
          ),
        ),
      );

      await expectLater(
        endpoints.product.listMyDrafts(buyerSession),
        throwsA(
          isA<ProductDraftException>().having(
            (e) => e.message,
            'message',
            'A Producer profile is required.',
          ),
        ),
      );

      final noProfileSession = await newUser();
      await expectLater(
        endpoints.product.createDraft(
          noProfileSession,
          name: 'No Profile',
          description: 'Should fail',
        ),
        throwsA(
          isA<ProductDraftException>().having(
            (e) => e.message,
            'message',
            'A Producer profile is required.',
          ),
        ),
      );
    });

    test('validates product draft input', () async {
      final producer = await newProducer();

      // Empty name
      for (final emptyName in ['', '   ']) {
        await expectLater(
          endpoints.product.createDraft(
            producer,
            name: emptyName,
            description: 'Some description',
          ),
          throwsA(
            isA<ProductDraftException>().having(
              (e) => e.message,
              'message',
              'Enter a name of 1 to 120 characters.',
            ),
          ),
        );
      }

      // Name exceeding 120 characters
      final longName = List.filled(121, 'a').join();
      await expectLater(
        endpoints.product.createDraft(
          producer,
          name: longName,
          description: 'Valid description',
        ),
        throwsA(
          isA<ProductDraftException>().having(
            (e) => e.message,
            'message',
            'Enter a name of 1 to 120 characters.',
          ),
        ),
      );

      // Description exceeding 2000 characters
      final longDescription = List.filled(2001, 'b').join();
      await expectLater(
        endpoints.product.createDraft(
          producer,
          name: 'Valid Name',
          description: longDescription,
        ),
        throwsA(
          isA<ProductDraftException>().having(
            (e) => e.message,
            'message',
            'Use at most 2000 description characters.',
          ),
        ),
      );

      // Verify no drafts were created
      final drafts = await endpoints.product.listMyDrafts(producer);
      expect(drafts, isEmpty);
    });

    test('successfully persists and lists product drafts', () async {
      final producer = await newProducer(name: 'Artisan Producer');

      final draft1 = await endpoints.product.createDraft(
        producer,
        name: '  Copper Bottle  ',
        description: '  Handmade pure copper bottle.  ',
      );

      expect(draft1.id, isNotNull);
      expect(draft1.name, 'Copper Bottle');
      expect(draft1.description, 'Handmade pure copper bottle.');
      expect(draft1.status, ProductStatus.draft);

      final draft2 = await endpoints.product.createDraft(
        producer,
        name: 'Clay Pot',
        description: '',
      );

      expect(draft2.id, isNotNull);
      expect(draft2.name, 'Clay Pot');
      expect(draft2.description, '');
      expect(draft2.status, ProductStatus.draft);

      final myDrafts = await endpoints.product.listMyDrafts(producer);
      expect(myDrafts.length, 2);
      expect(myDrafts[0].id, draft2.id); // Descending by id
      expect(myDrafts[0].name, 'Clay Pot');
      expect(myDrafts[1].id, draft1.id);
      expect(myDrafts[1].name, 'Copper Bottle');
    });

    test('isolates drafts between different producer accounts', () async {
      final producer1 = await newProducer(name: 'Producer One');
      final producer2 = await newProducer(name: 'Producer Two');

      final draft1 = await endpoints.product.createDraft(
        producer1,
        name: 'Producer 1 Silk Scarf',
        description: 'Pure silk',
      );

      final draft2 = await endpoints.product.createDraft(
        producer2,
        name: 'Producer 2 Brass Lamp',
        description: 'Antique finish',
      );

      final list1 = await endpoints.product.listMyDrafts(producer1);
      final list2 = await endpoints.product.listMyDrafts(producer2);

      expect(list1.map((p) => p.id), contains(draft1.id));
      expect(list1.map((p) => p.id), isNot(contains(draft2.id)));

      expect(list2.map((p) => p.id), contains(draft2.id));
      expect(list2.map((p) => p.id), isNot(contains(draft1.id)));
    });
  });
}
