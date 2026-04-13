import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notifications_repository.dart';

/// حالة استخدام: الحصول على عدد الإشعارات غير المقروءة
class GetUnreadCountUseCase {
  final NotificationsRepository repository;

  GetUnreadCountUseCase(this.repository);

  Future<Either<Failure, int>> call(String userId) {
    return repository.getUnreadCount(userId);
  }
}
