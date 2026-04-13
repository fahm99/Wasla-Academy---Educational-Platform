import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/course_model.dart';
import '../repositories/courses_repository.dart';

/// حالة استخدام: الحصول على جميع الكورسات
class GetAllCoursesUseCase {
  final CoursesRepository repository;

  GetAllCoursesUseCase(this.repository);

  Future<Either<Failure, List<CourseModel>>> call() async {
    return await repository.getAllCourses();
  }
}
