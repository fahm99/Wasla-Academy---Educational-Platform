import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exam_result.dart';
import '../repositories/exams_repository.dart';

/// حالة استخدام: إرسال إجابات الامتحان
class SubmitExamAnswersUseCase {
  final ExamsRepository repository;

  SubmitExamAnswersUseCase(this.repository);

  Future<Either<Failure, ExamResult>> call({
    required String examId,
    required String studentId,
    required Map<String, String> answers,
  }) async {
    return await repository.submitExamAnswers(
      examId: examId,
      studentId: studentId,
      answers: answers,
    );
  }
}
