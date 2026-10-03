import 'dart:io';

import 'package:flutter_ci/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete login flow', (tester) async {
    // Start video recording in the background before launching the app
    // NOTE in "macos/Runner/DebugProfile.entitlements" set <key>com.apple.security.app-sandbox</key> to false
    final ffmpegProcess = await Process.start('ffmpeg', [
      '-f',
      'avfoundation',
      '-capture_cursor',
      '1',
      '-framerate',
      '30',
      '-i',
      '0:none',
      '-c:v',
      'h264_videotoolbox',
      '-b:v',
      '2M',
      'integration_test_execution.mp4',
    ]);

    try {
      // 1. Launch app
      app.main();
      await tester.pumpAndSettle();

      // 2. Find widgets directly using keys
      final emailField = find.byKey(.new('email'));
      final passwordField = find.byKey(.new('password'));
      final submitButton = find.byKey(.new('submit'));

      // 3. Interact with UI
      await tester.enterText(emailField, 'user@example.com');
      await tester.enterText(passwordField, 'secret123');
      await tester.tap(submitButton);

      // 4. Wait for navigation / state update
      await tester.pumpAndSettle();

      // 5. Verify outcome
      expect(find.text('welcome'), findsOneWidget);
      await Future.delayed(.new(seconds: 4));
    } finally {
      // Gracefully stop ffmpeg recording (equivalent to kill -INT)
      ffmpegProcess.kill(.sigint);

      // Wait for ffmpeg to finish writing and closing the video file
      await ffmpegProcess.exitCode;
    }
  });
}
