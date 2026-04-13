import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/module_model.dart';
import '../repositories/courses_repository.dart';

/// حالة استخدام: الحصول على وحدات الكورس
class GetCourseModulesUseCase {
  final CoursesRepository repository;

  GetCourseModulesUseCase(this.repository);

  Future<Either<Failure, List<ModuleModel>>> call(String courseId) async {
    return await repository.getCourseModules(courseId);
  }
}
