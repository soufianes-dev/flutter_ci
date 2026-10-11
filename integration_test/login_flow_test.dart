import 'dart:convert';
import 'dart:io';

import 'package:flutter_ci/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  HttpServer? hostBridgeServer;
  setUpAll(() async {
    // 1. Bind server to any IPv4 interface on port 8080
    hostBridgeServer = await .bind(InternetAddress.anyIPv4, 8080);
    hostBridgeServer!.listen((req) async {
      try {
        final content = await utf8.decoder.bind(req).join();
        final data = content.isNotEmpty ? jsonDecode(content) : {};

        if (req.uri.path == '/ping-host') {
          // Send response back to the host OS
          req.response.statusCode = HttpStatus.ok;
          req.response.write(
            jsonEncode({'status': 'acknowledged', 'received': data}),
          );
        } else {
          req.response.statusCode = HttpStatus.notFound;
          req.response.write('Endpoint not found');
        }
      } catch (e) {
        req.response.statusCode = HttpStatus.internalServerError;
        req.response.write(jsonEncode({'error': e.toString()}));
      } finally {
        await req.response.close();
      }
    });
  });

  tearDownAll(() async {
    // Clean up server after test completion
    await hostBridgeServer?.close(force: true);
  });

  testWidgets('Complete login flow', (tester) async {
    // Start video recording in the background before launching the app
    // NOTE in "macos/Runner/DebugProfile.entitlements" set <key>com.apple.security.app-sandbox</key> to false
    late final Process process;
    if (Platform.isMacOS) {
      process = await Process.start('ffmpeg', [
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
    } else if (Platform.isWindows) {
      process = await Process.start('ffmpeg', [
        '-f',
        'gdigrab',
        '-framerate',
        '30',
        '-i',
        'desktop',
        '-c:v',
        'libx264',
        '-pix_fmt',
        'yuv420p',
        '-b:v',
        '2M',
        'integration_test_execution.mp4',
      ]);
    } else if (Platform.isLinux) {
      final display = Platform.environment['DISPLAY'] ?? ':0.0';
      // WSL
      process = await Process.start('ffmpeg', [
        '-f',
        'x11grab',
        '-framerate',
        '30',
        // '-video_size',
        // '1920x1080', // Adjust to match WSL display resolution
        '-i',
        display,
        '-c:v',
        'libx264',
        '-preset',
        'ultrafast',
        '-pix_fmt',
        'yuv420p',
        'integration_test_execution.mp4',
      ]);

      process.stderr.transform(utf8.decoder).listen((event) {
        print('FFmpeg Error: $event');
      });
    }
    //  else if (Platform.isAndroid) {
    //   // Start Android screen recording via ADB
    //   process = await Process.start(Platform.isWindows ? 'adb.exe' : 'adb', [
    //     'shell',
    //     'screenrecord',
    //     '/data/local/tmp/integration_test_execution.mp4',
    //   ], runInShell: true);
    // } else if (Platform.isIOS) {
    //   // Start iOS Simulator screen recording via xcrun simctl
    //   process = await Process.start('xcrun', [
    //     'simctl',
    //     'io',
    //     'booted',
    //     'recordVideo',
    //     'integration_test_execution.mp4',
    //   ]);
    // }

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
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        // Gracefully stop ffmpeg recording (equivalent to kill -INT)
        process.kill(.sigint);

        // Wait for ffmpeg to finish writing and closing the video file
        await process.exitCode;
      }
      //  else if (Platform.isAndroid) {
      //   // Stop the screenrecord process gracefully (sends SIGINT / Ctrl+C)
      //   process.kill(.sigint);
      //   await process.exitCode;

      //   // Pull the video file from the emulator and wait for it to finish
      //   await Process.run(Platform.isWindows ? 'adb.exe' : 'adb', [
      //     'pull',
      //     '/data/local/tmp/integration_test_execution.mp4',
      //     'integration_test_execution.mp4',
      //   ], runInShell: true);

      //   // Clean up the temporary file from the device
      //   await Process.run(Platform.isWindows ? 'adb.exe' : 'adb', [
      //     'shell',
      //     'rm',
      //     '/data/local/tmp/integration_test_execution.mp4',
      //   ], runInShell: true);
      // } else if (Platform.isIOS) {
      //   // Stop simulator video recording process
      //   process.kill(.sigint);
      //   await process.exitCode;
      // }
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
