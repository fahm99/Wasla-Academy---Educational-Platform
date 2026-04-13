import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/lesson_progress_model.dart';
import '../models/enrollment_progress_model.dart';

/// مصدر البيانات البعيد لنظام التعلم
abstract class LearningRemoteDataSource {
  /// الحصول على تقدم الطالب في كورس معين
  Future<EnrollmentProgressModel> getEnrollmentProgress(
      String studentId, String courseId);

  /// الحصول على تقدم درس معين
  Future<LessonProgressModel?> getLessonProgress(
      String studentId, String lessonId);

  /// تحديث تقدم درس
  Future<LessonProgressModel> updateLessonProgress({
    required String studentId,
    required String lessonId,
    required int watchedDuration,
    required bool isCompleted,
  });

  /// تحديث تقدم التسجيل
  Future<void> updateEnrollmentProgress(
      String studentId, String courseId, int completionPercentage);

  /// الحصول على جميع دروس الكورس مع التقدم
  Future<List<Map<String, dynamic>>> getCourseLessonsWithProgress(
      String studentId, String courseId);
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  final SupabaseClient supabaseClient;

  LearningRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<EnrollmentProgressModel> getEnrollmentProgress(
      String studentId, String courseId) async {
    try {
      final response = await supabaseClient
          .from('enrollments')
          .select()
          .eq('student_id', studentId)
          .eq('course_id', courseId)
          .single();

      return EnrollmentProgressModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LessonProgressModel?> getLessonProgress(
      String studentId, String lessonId) async {
    try {
      final response = await supabaseClient
          .from('lesson_progress')
          .select()
          .eq('student_id', studentId)
          .eq('lesson_id', lessonId)
          .maybeSingle();

      if (response == null) return null;

      return LessonProgressModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LessonProgressModel> updateLessonProgress({
    required String studentId,
    required String lessonId,
    required int watchedDuration,
    required bool isCompleted,
  }) async {
    try {
      // الحصول على معلومات الدرس
      final lessonResponse = await supabaseClient
          .from('lessons')
          .select('id, course_id, video_duration')
          .eq('id', lessonId)
          .single();

      final courseId = lessonResponse['course_id'] as String;
      final totalDuration = lessonResponse['video_duration'] as int? ?? 0;

      // تحديث أو إنشاء تقدم الدرس
      final progressData = {
        'student_id': studentId,
        'lesson_id': lessonId,
        'watched_duration': watchedDuration,
        'is_completed': isCompleted,
        if (isCompleted) 'completed_at': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('lesson_progress')
          .upsert(progressData)
          .select()
          .single();

      // تحديث نسبة إكمال الكورس
      await _updateCourseCompletionPercentage(studentId, courseId);

      return LessonProgressModel.fromJson({
        ...response,
        'course_id': courseId,
        'total_duration': totalDuration,
        'last_watched_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateEnrollmentProgress(
      String studentId, String courseId, int completionPercentage) async {
    try {
      await supabaseClient.from('enrollments').update({
        'completion_percentage': completionPercentage,
        'last_accessed': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).match({
        'student_id': studentId,
        'course_id': courseId,
      });
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCourseLessonsWithProgress(
      String studentId, String courseId) async {
    try {
      // الحصول على جميع الدروس
      final lessonsResponse = await supabaseClient
          .from('lessons')
          .select('*, modules!inner(id, title, order_number)')
          .eq('course_id', courseId)
          .order('order_number');

      // الحصول على تقدم الطالب
      final progressResponse = await supabaseClient
          .from('lesson_progress')
          .select()
          .eq('student_id', studentId);

      // دمج البيانات
      final progressMap = {for (var p in progressResponse) p['lesson_id']: p};

      return (lessonsResponse as List).map((lesson) {
        final lessonId = lesson['id'];
        final progress = progressMap[lessonId];

        return {
          ...Map<String, dynamic>.from(lesson),
          'progress': progress,
        };
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// تحديث نسبة إكمال الكورس
  Future<void> _updateCourseCompletionPercentage(
      String studentId, String courseId) async {
    try {
      // حساب عدد الدروس المكتملة
      final completedResponse = await supabaseClient
          .from('lesson_progress')
          .select()
          .eq('student_id', studentId)
          .eq('is_completed', true);

      // حساب إجمالي الدروس في الكورس
      final totalResponse = await supabaseClient
          .from('lessons')
          .select()
          .eq('course_id', courseId);

      final completed = completedResponse.length;
      final total = totalResponse.length;

      if (total > 0) {
        final percentage = ((completed / total) * 100).round();
        await updateEnrollmentProgress(studentId, courseId, percentage);
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث التلقائي
    }
  }
}
