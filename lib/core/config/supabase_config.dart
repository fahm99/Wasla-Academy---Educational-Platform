/// تكوين Supabase
///
/// يحتوي على جميع الإعدادات الخاصة بـ Supabase
class SupabaseConfig {
  static const String supabaseUrl = 'https://hmgisljihrsztskvmbfd.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhtZ2lzbGppaHJzenRza3ZtYmZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU1NjAyNjEsImV4cCI6MjA5MTEzNjI2MX0.Aunodx4B6O9hgSeEtJa3iKg9ydbxYK601kYUIINpr2g';
  // Storage Buckets
  static const String courseVideosBucket = 'course-videos';
  static const String courseFilesBucket = 'course-files';
  static const String courseImagesBucket = 'course-images';
  static const String certificatesBucket = 'certificates';
  static const String avatarsBucket = 'avatars';

  // API Endpoints (إذا كنت تستخدم Edge Functions)
  static const String edgeFunctionsUrl = '$supabaseUrl/functions/v1';

  // Realtime Configuration
  static const bool enableRealtime = true;

  // Auth Configuration
  static const bool persistSession = true;
  static const bool autoRefreshToken = true;

  // Storage Configuration
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedImageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];
  static const List<String> allowedVideoTypes = ['mp4', 'webm', 'mov'];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'ppt',
    'pptx'
  ];

  // Validation
  static bool isConfigured() {
    return supabaseUrl != 'YOUR_SUPABASE_PROJECT_URL' &&
        supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY';
  }
}
