import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Use Case لتسجيل حساب جديد
class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserModel>> call({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }
}
