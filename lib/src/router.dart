import 'package:go_router/go_router.dart';

import 'ui/pages/login.dart';
import 'ui/pages/welcome.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  routes: <GoRoute>[
    .new(path: "/login", builder: (context, state) => const Login()),
    .new(path: "/welcome", builder: (context, state) => const Welcome()),
  ],
);
