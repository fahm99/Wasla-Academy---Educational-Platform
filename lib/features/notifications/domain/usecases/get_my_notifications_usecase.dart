import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification.dart';
import '../repositories/notifications_repository.dart';

/// حالة استخدام: الحصول على إشعارات المستخدم
class GetMyNotificationsUseCase {
  final NotificationsRepository repository;

  GetMyNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call(String userId) {
    return repository.getMyNotifications(userId);
  }
}
