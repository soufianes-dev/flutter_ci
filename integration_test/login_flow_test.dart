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
    } finally {
      // Gracefully stop ffmpeg recording (equivalent to kill -INT)
      ffmpegProcess.kill(.sigint);

      // Wait for ffmpeg to finish writing and closing the video file
      await ffmpegProcess.exitCode;
    }
  });
}

// The purpose of the following commands is to override system dialogs (permission dialogs in Android and iOS)

// iOS Simulator
// Pre-grant camera and location permissions before running tests
// xcrun simctl privacy booted grant camera dev.soufianes.flutterci
// xcrun simctl privacy booted grant location dev.soufianes.flutterci
// iOS screenshot
// xcrun simctl io booted screenshot screenshot.png

// Record a video
// xcrun simctl io booted recordVideo video.mp4 & & // Start command 
// pkill -INT -f "simctl io" // End command


// Android emulator (adb)
// Pre-grant runtime permissions via ADB
// adb shell pm grant dev.soufianes.flutterci android.permission.CAMERA
// adb shell pm grant dev.soufianes.flutterci android.permission.ACCESS_FINE_LOCATION

// Android GPS Spoofing
// adb emu geo fix -122.084 37.422

// Android screenshot
// adb exec-out screencap -p > screenshot.png

// Android network disconnection
// adb shell svc wifi disable && adb shell svc data disable

// We can send physical coordinate taps or key events directly to the Android OS layer:
// Tap at exact screen coordinates (X, Y) corresponding to a native "Allow" button
// await Process.run('adb', ['shell', 'input', 'tap', '500', '1200']);
// Or press the physical Home or Back button on Android
// await Process.run('adb', ['shell', 'input', 'keyevent', '4']); // KEYCODE_BACK

// Inside our dart test when a native macOS dialog opens:
// await Process.run('osascript', [
//   'e',
//   'tell application "System Events" to click button "Allow" of window 1 of process "Runner"'
// ]);
