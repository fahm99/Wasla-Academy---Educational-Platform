import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exam_result.dart';
import '../repositories/exams_repository.dart';

/// حالة استخدام: الحصول على نتائج امتحاناتي
class GetMyExamResultsUseCase {
  final ExamsRepository repository;

  GetMyExamResultsUseCase(this.repository);

  Future<Either<Failure, List<ExamResult>>> call(String studentId) async {
    return await repository.getMyExamResults(studentId);
  }
}
