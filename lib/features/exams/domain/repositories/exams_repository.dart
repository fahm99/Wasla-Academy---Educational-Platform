import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exam.dart';
import '../entities/exam_question.dart';
import '../entities/exam_result.dart';

/// واجهة مستودع الامتحانات
abstract class ExamsRepository {
  /// الحصول على امتحانات الكورس
  Future<Either<Failure, List<Exam>>> getCourseExams(String courseId);

  /// الحصول على امتحان معين
  Future<Either<Failure, Exam>> getExam(String examId);

  /// الحصول على أسئلة الامتحان
  Future<Either<Failure, List<ExamQuestion>>> getExamQuestions(String examId);

  /// إرسال إجابات الامتحان
  Future<Either<Failure, ExamResult>> submitExamAnswers({
    required String examId,
    required String studentId,
    required Map<String, String> answers,
  });

  /// الحصول على نتائج امتحانات الطالب
  Future<Either<Failure, List<ExamResult>>> getMyExamResults(String studentId);

  /// الحصول على نتيجة امتحان معين
  Future<Either<Failure, ExamResult?>> getExamResult(
      String examId, String studentId);

  /// التحقق من إمكانية إعادة الامتحان
  Future<Either<Failure, bool>> canRetakeExam(String examId, String studentId);
}
