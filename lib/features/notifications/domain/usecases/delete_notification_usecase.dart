import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notifications_repository.dart';

/// حالة استخدام: حذف إشعار
class DeleteNotificationUseCase {
  final NotificationsRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(String notificationId) {
    return repository.deleteNotification(notificationId);
  }
}
