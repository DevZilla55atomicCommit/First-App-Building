// Core constants for the app
class AppConstants {
  AppConstants._();

  static const String appName = 'First App Building';
  static const String appVersion = '1.0.0';
  static const String bundleId = 'com.example.firstappbuilding';

  // API
  static const String baseUrl = 'https://api.example.com';
  static const int apiTimeoutSeconds = 30;

  // Storage keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // Feature flags
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
}