/// تكوين التطبيق العام
class AppConfig {
  // App Information
  static const String appName = 'منصة وصلة أكاديمي';
  static const String appNameEn = 'Wasla Academy';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const int apiTimeout = 30; // seconds
  static const int maxRetries = 3;

  // Pagination
  static const int coursesPerPage = 10;
  static const int notificationsPerPage = 20;
  static const int paymentsPerPage = 15;

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50 MB

  // Video Player Configuration
  static const bool autoPlayVideos = false;
  static const bool showVideoControls = true;
  static const double defaultPlaybackSpeed = 1.0;

  // Payment Configuration
  static const String defaultCurrency = 'SAR';
  static const List<String> supportedPaymentMethods = [
    'bank_transfer',
    'local_transfer',
  ];

  // Exam Configuration
  static const int defaultExamDuration = 60; // minutes
  static const int defaultMaxAttempts = 3;
  static const int passingScore = 60; // percentage

  // Certificate Configuration
  static const bool autoIssueCertificates = true;
  static const int certificateValidityYears = 0; // 0 means no expiry

  // Notification Configuration
  static const bool enablePushNotifications = true;
  static const bool enableEmailNotifications = true;

  // UI Configuration
  static const String defaultLanguage = 'ar';
  static const String defaultTheme = 'light';

  // Debug Configuration
  static const bool enableDebugMode = true;
  static const bool enableLogging = true;
}
