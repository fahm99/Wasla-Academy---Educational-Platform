import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Use Case للحصول على المستخدم الحالي
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserModel?>> call() async {
    return await repository.getCurrentUser();
  }
}
