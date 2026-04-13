import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notifications_repository.dart';

/// حالة استخدام: تحديد إشعار كمقروء
class MarkAsReadUseCase {
  final NotificationsRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
