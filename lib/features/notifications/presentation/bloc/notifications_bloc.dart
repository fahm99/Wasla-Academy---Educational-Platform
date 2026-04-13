import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/get_my_notifications_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Bloc لإدارة حالة الإشعارات
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetMyNotificationsUseCase getMyNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final NotificationsRepository repository;

  StreamSubscription? _notificationsSubscription;

  NotificationsBloc({
    required this.getMyNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
    required this.getUnreadCountUseCase,
    required this.deleteNotificationUseCase,
    required this.repository,
  }) : super(NotificationsInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllAsRead);
    on<LoadUnreadCountEvent>(_onLoadUnreadCount);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<SubscribeToNotificationsEvent>(_onSubscribeToNotifications);
    on<UnsubscribeFromNotificationsEvent>(_onUnsubscribeFromNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    final notificationsResult = await getMyNotificationsUseCase(event.userId);
    final unreadCountResult = await getUnreadCountUseCase(event.userId);

    notificationsResult.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) {
        unreadCountResult.fold(
          (failure) => emit(NotificationsLoaded(
            notifications: notifications,
            unreadCount: 0,
          )),
          (count) => emit(NotificationsLoaded(
            notifications: notifications,
            unreadCount: count,
          )),
        );
      },
    );
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await markAsReadUseCase(event.notificationId);

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) => emit(NotificationMarkedAsRead(event.notificationId)),
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await markAllAsReadUseCase(event.userId);

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) => emit(AllNotificationsMarkedAsRead()),
    );
  }

  Future<void> _onLoadUnreadCount(
    LoadUnreadCountEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await getUnreadCountUseCase(event.userId);

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (count) => emit(UnreadCountUpdated(count)),
    );
  }

  Future<void> _onDeleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await deleteNotificationUseCase(event.notificationId);

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) => emit(NotificationDeleted(event.notificationId)),
    );
  }

  Future<void> _onSubscribeToNotifications(
    SubscribeToNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await _notificationsSubscription?.cancel();

    _notificationsSubscription = repository
        .subscribeToNotifications(event.userId)
        .listen((notification) {
      add(LoadNotificationsEvent(event.userId));
    });
  }

  Future<void> _onUnsubscribeFromNotifications(
    UnsubscribeFromNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await _notificationsSubscription?.cancel();
    _notificationsSubscription = null;
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
