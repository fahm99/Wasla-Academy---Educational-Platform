import 'package:flutter_dotenv/flutter_dotenv.dart';

/// تكوين Supabase
///
/// يحتوي على جميع الإعدادات الخاصة بـ Supabase
class SupabaseConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Storage Buckets
  static const String courseVideosBucket = 'course-videos';
  static const String courseFilesBucket = 'course-files';
  static const String courseImagesBucket = 'course-images';
  static const String certificatesBucket = 'certificates';
  static const String avatarsBucket = 'avatars';

  // API Endpoints (إذا كنت تستخدم Edge Functions)
  static String get edgeFunctionsUrl => '$supabaseUrl/functions/v1';

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
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }
}
