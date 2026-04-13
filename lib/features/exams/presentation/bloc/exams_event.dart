part of 'exams_bloc.dart';

/// أحداث الامتحانات
abstract class ExamsEvent extends Equatable {
  const ExamsEvent();

  @override
  List<Object?> get props => [];
}

/// حدث: تحميل امتحانات الكورس
class LoadCourseExamsEvent extends ExamsEvent {
  final String courseId;
  final String studentId;

  const LoadCourseExamsEvent({
    required this.courseId,
    required this.studentId,
  });

  @override
  List<Object?> get props => [courseId, studentId];
}

/// حدث: تحميل الامتحان مع الأسئلة
class LoadExamWithQuestionsEvent extends ExamsEvent {
  final String examId;
  final String studentId;

  const LoadExamWithQuestionsEvent({
    required this.examId,
    required this.studentId,
  });

  @override
  List<Object?> get props => [examId, studentId];
}

/// حدث: إرسال إجابات الامتحان
class SubmitExamAnswersEvent extends ExamsEvent {
  final String examId;
  final String studentId;
  final Map<String, String> answers;

  const SubmitExamAnswersEvent({
    required this.examId,
    required this.studentId,
    required this.answers,
  });

  @override
  List<Object?> get props => [examId, studentId, answers];
}

/// حدث: تحميل نتائج امتحاناتي
class LoadMyExamResultsEvent extends ExamsEvent {
  final String studentId;

  const LoadMyExamResultsEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
