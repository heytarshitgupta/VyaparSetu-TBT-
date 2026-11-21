import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyaparsetu_ai/features/auth/profile_setup_form.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

void main() {
  testWidgets('requires a display name and explicit role', (tester) async {
    var saves = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileSetupForm(
            onSave: (_, _) async {
              saves++;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Save profile'));
    await tester.pump();

    expect(find.text('Enter a name of 1 to 80 characters.'), findsOneWidget);
    expect(find.text('Choose a role.'), findsOneWidget);
    expect(saves, 0);
  });

  testWidgets('submits trimmed name and shows a rejected save', (tester) async {
    final submissions = <(String, MarketplaceRole)>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileSetupForm(
            onSave: (name, role) async {
              submissions.add((name, role));
              throw ProfileException(
                message: 'This account already has a role.',
              );
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '  Maker  ');
    await tester.tap(find.text('Marketplace role'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Producer').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();

    expect(submissions, [('Maker', MarketplaceRole.producer)]);
    expect(find.text('This account already has a role.'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });
}
