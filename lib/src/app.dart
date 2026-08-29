import 'package:flutter/material.dart';

import 'router.dart';
import 'ui/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter App1',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: goRouter,
    );
  }
}
