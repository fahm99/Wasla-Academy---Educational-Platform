import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/enrollment_model.dart';
import '../repositories/courses_repository.dart';

/// حالة استخدام: الحصول على تسجيلاتي
class GetMyEnrollmentsUseCase {
  final CoursesRepository repository;

  GetMyEnrollmentsUseCase(this.repository);

  Future<Either<Failure, List<EnrollmentModel>>> call() async {
    return await repository.getMyEnrollments();
  }
}
