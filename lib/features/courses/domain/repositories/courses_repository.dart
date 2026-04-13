import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/course_model.dart';
import '../../data/models/module_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/enrollment_model.dart';

/// واجهة مستودع الكورسات
abstract class CoursesRepository {
  Future<Either<Failure, List<CourseModel>>> getAllCourses();

  Future<Either<Failure, List<CourseModel>>> searchCourses({
    String? query,
    String? category,
    String? level,
  });

  Future<Either<Failure, CourseModel>> getCourseById(String id);

  Future<Either<Failure, List<ModuleModel>>> getCourseModules(String courseId);

  Future<Either<Failure, List<LessonModel>>> getModuleLessons(String moduleId);

  Future<Either<Failure, EnrollmentModel>> enrollInCourse(String courseId);

  Future<Either<Failure, List<EnrollmentModel>>> getMyEnrollments();

  Future<Either<Failure, EnrollmentModel>> getEnrollmentByCourseId(
    String courseId,
  );
}
