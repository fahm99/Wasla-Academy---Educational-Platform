import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/exams_repository.dart';

/// حالة استخدام: التحقق من إمكانية إعادة الامتحان
class CanRetakeExamUseCase {
  final ExamsRepository repository;

  CanRetakeExamUseCase(this.repository);

  Future<Either<Failure, bool>> call(String examId, String studentId) async {
    return await repository.canRetakeExam(examId, studentId);
  }
}
