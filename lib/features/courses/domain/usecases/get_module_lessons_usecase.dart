import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/lesson_model.dart';
import '../repositories/courses_repository.dart';

/// حالة استخدام: الحصول على دروس الوحدة
class GetModuleLessonsUseCase {
  final CoursesRepository repository;

  GetModuleLessonsUseCase(this.repository);

  Future<Either<Failure, List<LessonModel>>> call(String moduleId) async {
    return await repository.getModuleLessons(moduleId);
  }
}
