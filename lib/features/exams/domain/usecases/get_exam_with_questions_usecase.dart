import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/exams_repository.dart';

/// حالة استخدام: الحصول على الامتحان مع الأسئلة
class GetExamWithQuestionsUseCase {
  final ExamsRepository repository;

  GetExamWithQuestionsUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String examId) async {
    final examResult = await repository.getExam(examId);

    return examResult.fold(
      (failure) => Left(failure),
      (exam) async {
        final questionsResult = await repository.getExamQuestions(examId);

        return questionsResult.fold(
          (failure) => Left(failure),
          (questions) => Right({
            'exam': exam,
            'questions': questions,
          }),
        );
      },
    );
  }
}
