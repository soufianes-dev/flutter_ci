import 'package:flutter_ci/src/app.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Tap on floating action button, and verify the counter', (
      widgetTester,
    ) async {
      await widgetTester.pumpWidget(const App());

      await widgetTester.pumpAndSettle();

      // Verify the count starts at 0
      expect(find.text('0'), findsOneWidget);

      // Finds the floating action button using tooltip to tap on
      final fab = find.byTooltip('Increment');
      // Or
      //final fab = find.byKey(ValueKey('increment'));

      // Emulate a tap on the floating action button
      await widgetTester.tap(fab);

      // Trigger a frame
      await widgetTester.pumpAndSettle();

      // Verify the counter increments by 1
      expect(find.text('1'), findsOneWidget);
    });
  });
}

// To test on mobile run : flutter test integration_test/app_test.dart
