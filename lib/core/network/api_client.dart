import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/error_handler.dart';

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

  /// تنفيذ طلب مع إعادة المحاولة التلقائية
  static Future<T> executeWithRetry<T>({
    required Future<T> Function() request,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 2),
    bool exponentialBackoff = true,
  }) async {
    int attempt = 0;
    Duration currentDelay = initialDelay;

    while (attempt < maxRetries) {
      try {
        return await request();
      } catch (e) {
        attempt++;

        // إذا وصلنا للحد الأقصى من المحاولات
        if (attempt >= maxRetries) {
          await ErrorHandler().logError(
            e,
            null,
            context:
                'ApiClient.executeWithRetry - فشل الطلب بعد $maxRetries محاولات',
          );
          rethrow;
        }

        // تسجيل المحاولة
        await ErrorHandler().logWarning(
          'محاولة $attempt من $maxRetries - إعادة المحاولة بعد ${currentDelay.inSeconds} ثانية',
          context: 'ApiClient.executeWithRetry',
        );

        // الانتظار قبل إعادة المحاولة
        await Future.delayed(currentDelay);

        // زيادة وقت الانتظار (Exponential Backoff)
        if (exponentialBackoff) {
          currentDelay = Duration(seconds: currentDelay.inSeconds * 2);
        }
      }
    }

    throw Exception('فشل تنفيذ الطلب بعد $maxRetries محاولات');
  }

  /// رفع ملف مع إعادة المحاولة
  static Future<String> uploadFileWithRetry({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    FileOptions? fileOptions,
    int maxRetries = 3,
    Function(double)? onProgress,
  }) async {
    return await executeWithRetry(
      request: () async {
        await storage.from(bucket).uploadBinary(
              path,
              fileBytes,
              fileOptions: fileOptions ?? const FileOptions(),
            );

        return storage.from(bucket).getPublicUrl(path);
      },
      maxRetries: maxRetries,
    );
  }
}
