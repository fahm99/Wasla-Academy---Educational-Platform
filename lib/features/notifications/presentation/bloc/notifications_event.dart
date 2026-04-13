part of 'notifications_bloc.dart';

/// أحداث الإشعارات
abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل الإشعارات
class LoadNotificationsEvent extends NotificationsEvent {
  final String userId;

  const LoadNotificationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// تحديد إشعار كمقروء
class MarkNotificationAsReadEvent extends NotificationsEvent {
  final String notificationId;

  const MarkNotificationAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// تحديد جميع الإشعارات كمقروءة
class MarkAllNotificationsAsReadEvent extends NotificationsEvent {
  final String userId;

  const MarkAllNotificationsAsReadEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// تحميل عدد الإشعارات غير المقروءة
class LoadUnreadCountEvent extends NotificationsEvent {
  final String userId;

  const LoadUnreadCountEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// حذف إشعار
class DeleteNotificationEvent extends NotificationsEvent {
  final String notificationId;

  const DeleteNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// الاشتراك في الإشعارات الفورية
class SubscribeToNotificationsEvent extends NotificationsEvent {
  final String userId;

  const SubscribeToNotificationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// إلغاء الاشتراك في الإشعارات الفورية
class UnsubscribeFromNotificationsEvent extends NotificationsEvent {
  const UnsubscribeFromNotificationsEvent();
}
