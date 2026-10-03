import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_ci/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete login flow', (WidgetTester tester) async {
    // 1. Launch app
    app.main();
    await tester.pumpAndSettle();

    // 2. Find widgets directly using Keys
    final emailField = find.byKey(const Key('email'));
    final passwordField = find.byKey(const Key('password'));
    final submitButton = find.byKey(const Key('submit'));

    // 3. Interact with UI
    await tester.enterText(emailField, 'user@example.com');
    await tester.enterText(passwordField, 'secret123');
    await tester.tap(submitButton);

    // 4. Wait for navigation / state update
    await tester.pumpAndSettle();

    // 5. Verify outcome
    expect(find.text('Welcome'), findsOneWidget);
  });
}
