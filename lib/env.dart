// --dart-define-from-file=.env
// or "--dart-define-from-file=api-keys.json

class Env {
  static String get appIdentifier => const String.fromEnvironment("APP_IDENTIFIER");
  static String get androidPackageName => const String.fromEnvironment("ANDROID_PACKAGE_NAME");
  static String get buildName => const String.fromEnvironment("BUILD_NAME");
  static String get buildNumber => const String.fromEnvironment("BUILD_NUMBER");
  static String get buildFlavor => const String.fromEnvironment("BUILD_FLAVOR");
  static String get buildType => const String.fromEnvironment("BUILD_TYPE");
  static String get ciPipelineId => const String.fromEnvironment("CI_PIPELINE_ID");
  static String get buildHost => const String.fromEnvironment("BUILD_HOST");
  static String get osTarget => const String.fromEnvironment("OS_TARGET");
  static String get compilerVersion => const String.fromEnvironment("COMPILER_VERSION");
  static String get dependencyLockHash => const String.fromEnvironment("DEPENDENCY_LOCK_HASH");
  static String get signingCertificate => const String.fromEnvironment("SIGNING_CERTIFICATE");
  static String get deviceCompatibility => const String.fromEnvironment("DEVICE_COMPATIBILITY");
  static String get apiBaseURL => const String.fromEnvironment("API_BASE_URL");
  static String get gitSha => const String.fromEnvironment("GIT_SHA");
  static String get gitBranch => const String.fromEnvironment("GIT_BRANCH");
  static String get buildTimestamp => const String.fromEnvironment("BUILD_TIMESTAMP");
}
