// --dart-define-from-file=.env
// or "--dart-define-from-file=api-keys.json

class Env {
  static String get buildName => const String.fromEnvironment("BUILD_NAME");
  static String get buildNumber => const String.fromEnvironment("BUILD_NUMBER");
  static String get gitSha => const String.fromEnvironment("GIT_SHA");
  static String get gitBranch => const String.fromEnvironment("GIT_BRANCH");
  static String get buildTimestamp => const String.fromEnvironment("BUILD_TIMESTAMP");
}
