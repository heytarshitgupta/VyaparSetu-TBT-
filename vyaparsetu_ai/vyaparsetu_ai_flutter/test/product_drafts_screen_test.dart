import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyaparsetu_ai/features/producer/product_drafts_screen.dart';
import 'package:vyaparsetu_ai/providers/product_drafts_provider.dart';
import 'package:vyaparsetu_ai/providers/session_provider.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

class _FakeProductDraftsNotifier extends ProductDraftsNotifier {
  _FakeProductDraftsNotifier(this.initialDrafts);
  final List<Product> initialDrafts;

  @override
  Future<List<Product>> build() async => initialDrafts;

  @override
  Future<Product> createDraft({
    required String name,
    required String description,
    ByteData? photo,
    int? pricePaise,
    String? category,
    String? unit,
  }) async {
    final draft = Product(
      id: 99,
      producerProfileId: 1,
      name: name,
      description: description,
      status: ProductStatus.draft,
    );
    state = AsyncData([draft, ...initialDrafts]);
    return draft;
  }
}

class _FakeSignedInUserId extends SignedInUserId {
  @override
  String? build() => 'producer-123';
}

void main() {
  testWidgets('renders empty state and validates empty name on save', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInUserIdProvider.overrideWith(_FakeSignedInUserId.new),
          productDraftsProvider.overrideWith(
            () => _FakeProductDraftsNotifier([]),
          ),
        ],
        child: const MaterialApp(home: ProductDraftsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Products'), findsOneWidget);
    expect(find.text('New draft'), findsOneWidget);
    expect(find.text('No products yet.'), findsOneWidget);

    // Try saving with empty name
    await tester.ensureVisible(find.text('Save draft'));
    await tester.tap(find.text('Save draft'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a name of 1 to 120 characters.'), findsOneWidget);
  });

  testWidgets('displays existing drafts and saves new draft', (tester) async {
    final existing = Product(
      id: 1,
      producerProfileId: 1,
      name: 'Existing Copper Mug',
      description: 'Handmade mug',
      status: ProductStatus.draft,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          signedInUserIdProvider.overrideWith(_FakeSignedInUserId.new),
          productDraftsProvider.overrideWith(
            () => _FakeProductDraftsNotifier([existing]),
          ),
        ],
        child: const MaterialApp(home: ProductDraftsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Existing Copper Mug'), findsOneWidget);
    expect(find.text('Handmade mug'), findsOneWidget);

    // Fill form and save
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Product name'),
      'New Clay Pot',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description (optional)'),
      'Terracotta pot',
    );
    await tester.ensureVisible(find.text('Save draft'));
    await tester.tap(find.text('Save draft'));
    await tester.pumpAndSettle();

    expect(find.text('Draft saved successfully.'), findsOneWidget);
    expect(find.text('New Clay Pot'), findsOneWidget);
  });
}
