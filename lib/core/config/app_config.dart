// App configuration and environment setup
class AppConfig {
  final String baseUrl;
  final String environment;
  final bool enableLogging;
  final bool enableAnalytics;

  AppConfig({
    required this.baseUrl,
    required this.environment,
    this.enableLogging = true,
    this.enableAnalytics = false,
  });

  static AppConfig development() => AppConfig(
    baseUrl: 'https://dev-api.example.com',
    environment: 'development',
    enableLogging: true,
  );

  static AppConfig staging() => AppConfig(
    baseUrl: 'https://staging-api.example.com',
    environment: 'staging',
    enableLogging: true,
  );

  static AppConfig production() => AppConfig(
    baseUrl: 'https://api.example.com',
    environment: 'production',
    enableLogging: false,
    enableAnalytics: true,
  );
}