import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call({
    required String userId,
    String? name,
    String? phone,
    String? bio,
  }) {
    return repository.updateProfile(
      userId: userId,
      name: name,
      phone: phone,
      bio: bio,
    );
  }
}
