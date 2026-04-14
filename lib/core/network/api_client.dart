import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// عميل API للتعامل مع Supabase
class ApiClient {
  /// الحصول على instance من Supabase Client
  static SupabaseClient get instance {
    return Supabase.instance.client;
  }

  /// الحصول على Auth Client
  static GoTrueClient get auth => instance.auth;

  /// الحصول على Storage Client
  static SupabaseStorageClient get storage => instance.storage;

  /// الحصول على Realtime Client
  static RealtimeClient get realtime => instance.realtime;

  /// تنفيذ استعلام
  static SupabaseQueryBuilder from(String table) {
    return instance.from(table);
  }

  /// رفع ملف
  static Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    FileOptions? fileOptions,
  }) async {
    await storage.from(bucket).uploadBinary(
          path,
          fileBytes,
          fileOptions: fileOptions ?? const FileOptions(),
        );

    return storage.from(bucket).getPublicUrl(path);
  }

  /// حذف ملف
  static Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    await storage.from(bucket).remove([path]);
  }

  /// الحصول على رابط عام للملف
  static String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return storage.from(bucket).getPublicUrl(path);
  }

  /// الحصول على رابط موقع للملف
  static Future<String> getSignedUrl({
    required String bucket,
    required String path,
    int expiresIn = 3600, // 1 hour
  }) async {
    return await storage.from(bucket).createSignedUrl(path, expiresIn);
  }

  /// الاستماع للتغييرات في الوقت الفعلي
  static RealtimeChannel channel(String channelName) {
    return instance.channel(channelName);
  }

  /// إغلاق الاتصال
  static Future<void> dispose() async {
    await instance.dispose();
  }
}
