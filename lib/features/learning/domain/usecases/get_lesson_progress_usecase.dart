import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lesson_progress.dart';
import '../repositories/learning_repository.dart';

/// حالة استخدام: الحصول على تقدم الدرس
class GetLessonProgressUseCase {
  final LearningRepository repository;

  GetLessonProgressUseCase(this.repository);

  Future<Either<Failure, LessonProgress?>> call(
      String studentId, String lessonId) async {
    return await repository.getLessonProgress(studentId, lessonId);
  }
}
