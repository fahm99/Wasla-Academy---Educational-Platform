import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lesson_progress.dart';
import '../entities/enrollment_progress.dart';

/// واجهة مستودع التعلم
abstract class LearningRepository {
  /// الحصول على تقدم الطالب في كورس معين
  Future<Either<Failure, EnrollmentProgress>> getEnrollmentProgress(
      String studentId, String courseId);

  /// الحصول على تقدم درس معين
  Future<Either<Failure, LessonProgress?>> getLessonProgress(
      String studentId, String lessonId);

  /// تحديث تقدم درس
  Future<Either<Failure, LessonProgress>> updateLessonProgress({
    required String studentId,
    required String lessonId,
    required int watchedDuration,
    required bool isCompleted,
  });

  /// الحصول على جميع دروس الكورس مع التقدم
  Future<Either<Failure, List<Map<String, dynamic>>>>
      getCourseLessonsWithProgress(String studentId, String courseId);
}
