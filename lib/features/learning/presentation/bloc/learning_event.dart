part of 'learning_bloc.dart';

/// أحداث التعلم
abstract class LearningEvent extends Equatable {
  const LearningEvent();

  @override
  List<Object?> get props => [];
}

/// حدث: تحميل دروس الكورس
class LoadCourseLessonsEvent extends LearningEvent {
  final String studentId;
  final String courseId;

  const LoadCourseLessonsEvent({
    required this.studentId,
    required this.courseId,
  });

  @override
  List<Object?> get props => [studentId, courseId];
}

/// حدث: تحديث تقدم الدرس
class UpdateLessonProgressEvent extends LearningEvent {
  final String studentId;
  final String lessonId;
  final int watchedDuration;
  final bool isCompleted;

  const UpdateLessonProgressEvent({
    required this.studentId,
    required this.lessonId,
    required this.watchedDuration,
    required this.isCompleted,
  });

  @override
  List<Object?> get props =>
      [studentId, lessonId, watchedDuration, isCompleted];
}

/// حدث: تحميل تقدم الدرس
class LoadLessonProgressEvent extends LearningEvent {
  final String studentId;
  final String lessonId;

  const LoadLessonProgressEvent({
    required this.studentId,
    required this.lessonId,
  });

  @override
  List<Object?> get props => [studentId, lessonId];
}

/// حدث: تحميل تقدم التسجيل
class LoadEnrollmentProgressEvent extends LearningEvent {
  final String studentId;
  final String courseId;

  const LoadEnrollmentProgressEvent({
    required this.studentId,
    required this.courseId,
  });

  @override
  List<Object?> get props => [studentId, courseId];
}
