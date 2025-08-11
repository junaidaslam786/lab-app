// class Env {
//   static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
//   static const String apiBaseUrl = String.fromEnvironment(
//     'API_BASE_URL',
//     defaultValue: 'http://127.0.0.1:3000',
//   );
// }

class Env {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const String? sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  static bool get isProd => env == 'prod';
  static bool get isStaging => env == 'staging';
  static bool get isDev => env == 'dev';
}
