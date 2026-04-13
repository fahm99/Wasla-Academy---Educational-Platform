import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/course_model.dart';
import '../repositories/courses_repository.dart';

/// حالة استخدام: الحصول على تفاصيل كورس
class GetCourseDetailsUseCase {
  final CoursesRepository repository;

  GetCourseDetailsUseCase(this.repository);

  Future<Either<Failure, CourseModel>> call(String courseId) async {
    return await repository.getCourseById(courseId);
  }
}
