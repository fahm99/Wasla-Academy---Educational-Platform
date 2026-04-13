import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Use Case لتسجيل الدخول
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, UserModel>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(
      email: email,
      password: password,
    );
  }
}
