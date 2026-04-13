import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notifications_repository.dart';

/// حالة استخدام: تحديد جميع الإشعارات كمقروءة
class MarkAllAsReadUseCase {
  final NotificationsRepository repository;

  MarkAllAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId) {
    return repository.markAllAsRead(userId);
  }
}
