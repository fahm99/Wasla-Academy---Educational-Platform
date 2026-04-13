import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/enrollment_model.dart';
import '../repositories/courses_repository.dart';

/// حالة استخدام: التسجيل في كورس
class EnrollInCourseUseCase {
  final CoursesRepository repository;

  EnrollInCourseUseCase(this.repository);

  Future<Either<Failure, EnrollmentModel>> call(String courseId) async {
    return await repository.enrollInCourse(courseId);
  }
}
