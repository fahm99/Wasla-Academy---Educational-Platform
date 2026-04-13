/// ثوابت التخزين المحلي
class StorageConstants {
  // SharedPreferences Keys
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyUserType = 'user_type';
  static const String keyUserAvatar = 'user_avatar';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';

  // Settings Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyEmailNotifications = 'email_notifications';
  static const String keyPushNotifications = 'push_notifications';

  // Cache Keys
  static const String keyCachedCourses = 'cached_courses';
  static const String keyCachedCategories = 'cached_categories';
  static const String keyCachedEnrollments = 'cached_enrollments';
  static const String keyCacheTimestamp = 'cache_timestamp';

  // Download Keys
  static const String keyDownloadedVideos = 'downloaded_videos';
  static const String keyDownloadedFiles = 'downloaded_files';

  // Progress Keys
  static const String keyLastWatchedLesson = 'last_watched_lesson';
  static const String keyWatchedDuration = 'watched_duration';

  // Onboarding Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyFirstLaunch = 'first_launch';
}
