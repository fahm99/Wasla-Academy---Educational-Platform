import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification.dart';

/// واجهة مستودع الإشعارات
abstract class NotificationsRepository {
  /// الحصول على إشعارات المستخدم
  Future<Either<Failure, List<NotificationEntity>>> getMyNotifications(
      String userId);

  /// تحديد إشعار كمقروء
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// تحديد جميع الإشعارات كمقروءة
  Future<Either<Failure, void>> markAllAsRead(String userId);

  /// الحصول على عدد الإشعارات غير المقروءة
  Future<Either<Failure, int>> getUnreadCount(String userId);

  /// حذف إشعار
  Future<Either<Failure, void>> deleteNotification(String notificationId);

  /// الاشتراك في الإشعارات الفورية
  Stream<NotificationEntity> subscribeToNotifications(String userId);
}
