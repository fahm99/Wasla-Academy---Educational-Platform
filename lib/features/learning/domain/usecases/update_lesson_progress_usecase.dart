import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lesson_progress.dart';
import '../repositories/learning_repository.dart';

/// حالة استخدام: تحديث تقدم الدرس
class UpdateLessonProgressUseCase {
  final LearningRepository repository;

  UpdateLessonProgressUseCase(this.repository);

  Future<Either<Failure, LessonProgress>> call({
    required String studentId,
    required String lessonId,
    required int watchedDuration,
    required bool isCompleted,
  }) async {
    return await repository.updateLessonProgress(
      studentId: studentId,
      lessonId: lessonId,
      watchedDuration: watchedDuration,
      isCompleted: isCompleted,
    );
  }
}
