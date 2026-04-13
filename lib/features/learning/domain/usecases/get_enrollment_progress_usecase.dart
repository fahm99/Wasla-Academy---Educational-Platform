import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/enrollment_progress.dart';
import '../repositories/learning_repository.dart';

/// حالة استخدام: الحصول على تقدم التسجيل
class GetEnrollmentProgressUseCase {
  final LearningRepository repository;

  GetEnrollmentProgressUseCase(this.repository);

  Future<Either<Failure, EnrollmentProgress>> call(
      String studentId, String courseId) async {
    return await repository.getEnrollmentProgress(studentId, courseId);
  }
}
