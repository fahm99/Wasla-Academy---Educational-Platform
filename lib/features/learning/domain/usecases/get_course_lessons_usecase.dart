import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/learning_repository.dart';

/// حالة استخدام: الحصول على دروس الكورس مع التقدم
class GetCourseLessonsUseCase {
  final LearningRepository repository;

  GetCourseLessonsUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      String studentId, String courseId) async {
    return await repository.getCourseLessonsWithProgress(studentId, courseId);
  }
}
