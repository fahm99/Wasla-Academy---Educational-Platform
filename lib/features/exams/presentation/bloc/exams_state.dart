part of 'exams_bloc.dart';

/// حالات الامتحانات
abstract class ExamsState extends Equatable {
  const ExamsState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class ExamsInitial extends ExamsState {}

/// حالة التحميل
class ExamsLoading extends ExamsState {}

/// حالة تحميل امتحانات الكورس بنجاح
class CourseExamsLoaded extends ExamsState {
  final List<Exam> exams;

  const CourseExamsLoaded(this.exams);

  @override
  List<Object?> get props => [exams];
}

/// حالة تحميل الامتحان مع الأسئلة بنجاح
class ExamWithQuestionsLoaded extends ExamsState {
  final Exam exam;
  final List<ExamQuestion> questions;
  final bool canRetake;

  const ExamWithQuestionsLoaded({
    required this.exam,
    required this.questions,
    required this.canRetake,
  });

  @override
  List<Object?> get props => [exam, questions, canRetake];
}

/// حالة إرسال الإجابات بنجاح
class ExamSubmitted extends ExamsState {
  final ExamResult result;

  const ExamSubmitted(this.result);

  @override
  List<Object?> get props => [result];
}

/// حالة تحميل نتائج الامتحانات بنجاح
class MyExamResultsLoaded extends ExamsState {
  final List<ExamResult> results;

  const MyExamResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

/// حالة الخطأ
class ExamsError extends ExamsState {
  final String message;

  const ExamsError(this.message);

  @override
  List<Object?> get props => [message];
}
