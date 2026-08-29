import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';

import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    Firebase.initializeApp();
  }

  runApp(const App());
}
