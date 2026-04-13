import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/exam_model.dart';
import '../models/exam_question_model.dart';
import '../models/exam_result_model.dart';

/// مصدر البيانات البعيد للامتحانات
abstract class ExamsRemoteDataSource {
  /// الحصول على امتحانات الكورس
  Future<List<ExamModel>> getCourseExams(String courseId);

  /// الحصول على امتحان معين
  Future<ExamModel> getExam(String examId);

  /// الحصول على أسئلة الامتحان
  Future<List<ExamQuestionModel>> getExamQuestions(String examId);

  /// إرسال إجابات الامتحان
  Future<ExamResultModel> submitExamAnswers({
    required String examId,
    required String studentId,
    required Map<String, String> answers,
  });

  /// الحصول على نتائج امتحانات الطالب
  Future<List<ExamResultModel>> getMyExamResults(String studentId);

  /// الحصول على نتيجة امتحان معين
  Future<ExamResultModel?> getExamResult(String examId, String studentId);

  /// التحقق من إمكانية إعادة الامتحان
  Future<bool> canRetakeExam(String examId, String studentId);
}

class ExamsRemoteDataSourceImpl implements ExamsRemoteDataSource {
  final SupabaseClient supabaseClient;

  ExamsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ExamModel>> getCourseExams(String courseId) async {
    try {
      final response = await supabaseClient
          .from('exams')
          .select()
          .eq('course_id', courseId)
          .eq('status', 'published')
          .order('created_at');

      return (response as List)
          .map((json) => ExamModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExamModel> getExam(String examId) async {
    try {
      final response =
          await supabaseClient.from('exams').select().eq('id', examId).single();

      return ExamModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ExamQuestionModel>> getExamQuestions(String examId) async {
    try {
      final response = await supabaseClient
          .from('exam_questions')
          .select()
          .eq('exam_id', examId)
          .order('order_number');

      return (response as List)
          .map((json) => ExamQuestionModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExamResultModel> submitExamAnswers({
    required String examId,
    required String studentId,
    required Map<String, String> answers,
  }) async {
    try {
      // الحصول على الامتحان والأسئلة
      final exam = await getExam(examId);
      final questions = await getExamQuestions(examId);

      // حساب النتيجة
      int score = 0;
      int totalScore = 0;

      for (var question in questions) {
        totalScore += question.points;
        final studentAnswer = answers[question.id];
        if (studentAnswer != null &&
            studentAnswer.trim().toLowerCase() ==
                question.correctAnswer?.trim().toLowerCase()) {
          score += question.points;
        }
      }

      final percentage = totalScore > 0 ? (score / totalScore * 100) : 0.0;
      final passed = percentage >= exam.passingScore;

      // الحصول على عدد المحاولات السابقة
      final previousAttempts = await supabaseClient
          .from('exam_results')
          .select()
          .eq('exam_id', examId)
          .eq('student_id', studentId);

      final attemptNumber = previousAttempts.length + 1;

      // حفظ النتيجة
      final resultData = {
        'exam_id': examId,
        'student_id': studentId,
        'score': score,
        'total_score': totalScore,
        'percentage': percentage,
        'passed': passed,
        'attempt_number': attemptNumber,
        'completed_at': DateTime.now().toIso8601String(),
        'answers': answers,
      };

      final response = await supabaseClient
          .from('exam_results')
          .insert(resultData)
          .select()
          .single();

      return ExamResultModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ExamResultModel>> getMyExamResults(String studentId) async {
    try {
      final response = await supabaseClient
          .from('exam_results')
          .select('*, exams!inner(title, course_id)')
          .eq('student_id', studentId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ExamResultModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExamResultModel?> getExamResult(
      String examId, String studentId) async {
    try {
      final response = await supabaseClient
          .from('exam_results')
          .select()
          .eq('exam_id', examId)
          .eq('student_id', studentId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return ExamResultModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> canRetakeExam(String examId, String studentId) async {
    try {
      // الحصول على الامتحان
      final exam = await getExam(examId);

      // إذا لم يسمح بإعادة الامتحان
      if (!exam.allowRetake) {
        final result = await getExamResult(examId, studentId);
        return result == null; // يمكن الدخول فقط إذا لم يدخل من قبل
      }

      // حساب عدد المحاولات
      final attempts = await supabaseClient
          .from('exam_results')
          .select()
          .eq('exam_id', examId)
          .eq('student_id', studentId);

      return attempts.length < exam.maxAttempts;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
