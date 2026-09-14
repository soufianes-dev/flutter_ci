import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:material_ui/material_ui.dart';

import 'env.dart';
import 'src/app.dart';

void main() {
  // Environment Variables

  assert(Env.buildName.isNotEmpty, "BUILD_NAME is not defined!");
  log(Env.buildName);

  assert(Env.buildNumber.isNotEmpty, "BUILD_NUMBER is not defined!");
  log(Env.buildNumber);

  assert(Env.gitSha.isNotEmpty, "GIT_SHA is not defined!");
  log(Env.gitSha);

  assert(Env.gitBranch.isNotEmpty, "GIT_BRANCH is not defined!");
  log(Env.gitBranch);

  assert(Env.buildTimestamp.isNotEmpty, "BUILD_TIMESTAMP is not defined!");
  log(Env.buildTimestamp);


  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    Firebase.initializeApp();
  }

  runApp(const App());
}
