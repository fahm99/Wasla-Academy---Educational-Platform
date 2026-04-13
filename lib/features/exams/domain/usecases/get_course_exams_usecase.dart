import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exam.dart';
import '../repositories/exams_repository.dart';

/// حالة استخدام: الحصول على امتحانات الكورس
class GetCourseExamsUseCase {
  final ExamsRepository repository;

  GetCourseExamsUseCase(this.repository);

  Future<Either<Failure, List<Exam>>> call(String courseId) async {
    return await repository.getCourseExams(courseId);
  }
}
