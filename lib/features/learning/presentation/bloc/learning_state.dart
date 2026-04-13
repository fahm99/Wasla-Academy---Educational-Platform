part of 'learning_bloc.dart';

/// حالات التعلم
abstract class LearningState extends Equatable {
  const LearningState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class LearningInitial extends LearningState {}

/// حالة التحميل
class LearningLoading extends LearningState {}

/// حالة تحميل دروس الكورس بنجاح
class CourseLessonsLoaded extends LearningState {
  final List<Map<String, dynamic>> lessons;

  const CourseLessonsLoaded(this.lessons);

  @override
  List<Object?> get props => [lessons];
}

/// حالة تحديث تقدم الدرس بنجاح
class LessonProgressUpdated extends LearningState {
  final LessonProgress progress;

  const LessonProgressUpdated(this.progress);

  @override
  List<Object?> get props => [progress];
}

/// حالة تحميل تقدم الدرس بنجاح
class LessonProgressLoaded extends LearningState {
  final LessonProgress? progress;

  const LessonProgressLoaded(this.progress);

  @override
  List<Object?> get props => [progress];
}

/// حالة تحميل تقدم التسجيل بنجاح
class EnrollmentProgressLoaded extends LearningState {
  final EnrollmentProgress progress;

  const EnrollmentProgressLoaded(this.progress);

  @override
  List<Object?> get props => [progress];
}

/// حالة الخطأ
class LearningError extends LearningState {
  final String message;

  const LearningError(this.message);

  @override
  List<Object?> get props => [message];
}
