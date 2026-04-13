import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/notification_model.dart';

/// مصدر البيانات البعيد للإشعارات
abstract class NotificationsRemoteDataSource {
  /// الحصول على إشعارات المستخدم
  Future<List<NotificationModel>> getMyNotifications(String userId);

  /// تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId);

  /// تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead(String userId);

  /// الحصول على عدد الإشعارات غير المقروءة
  Future<int> getUnreadCount(String userId);

  /// حذف إشعار
  Future<void> deleteNotification(String notificationId);

  /// الاشتراك في الإشعارات الفورية
  Stream<NotificationModel> subscribeToNotifications(String userId);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final SupabaseClient supabaseClient;

  NotificationsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<NotificationModel>> getMyNotifications(String userId) async {
    try {
      final response = await supabaseClient
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await supabaseClient
          .from('notifications')
          .update({'is_read': true}).eq('id', notificationId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      await supabaseClient
          .from('notifications')
          .update({'is_read': true}).eq('user_id', userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await supabaseClient
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await supabaseClient
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<NotificationModel> subscribeToNotifications(String userId) {
    try {
      return supabaseClient
          .from('notifications')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .map((data) => data.map((json) => NotificationModel.fromJson(json)))
          .expand((notifications) => notifications);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
