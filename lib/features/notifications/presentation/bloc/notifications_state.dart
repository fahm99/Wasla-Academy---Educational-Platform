part of 'notifications_bloc.dart';

/// حالات الإشعارات
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class NotificationsInitial extends NotificationsState {}

/// جاري التحميل
class NotificationsLoading extends NotificationsState {}

/// تم تحميل الإشعارات
class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

/// تم تحديد إشعار كمقروء
class NotificationMarkedAsRead extends NotificationsState {
  final String notificationId;

  const NotificationMarkedAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// تم تحديد جميع الإشعارات كمقروءة
class AllNotificationsMarkedAsRead extends NotificationsState {}

/// تم حذف إشعار
class NotificationDeleted extends NotificationsState {
  final String notificationId;

  const NotificationDeleted(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// تم تحديث عدد الإشعارات غير المقروءة
class UnreadCountUpdated extends NotificationsState {
  final int count;

  const UnreadCountUpdated(this.count);

  @override
  List<Object?> get props => [count];
}

/// إشعار جديد من Realtime
class NewNotificationReceived extends NotificationsState {
  final NotificationEntity notification;

  const NewNotificationReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}

/// خطأ
class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
