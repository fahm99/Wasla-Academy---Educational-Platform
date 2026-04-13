import 'package:equatable/equatable.dart';

/// كيان تقدم الدرس
class LessonProgress extends Equatable {
  final String id;
  final String studentId;
  final String lessonId;
  final bool isCompleted;
  final int watchedDuration; // بالثواني
  final DateTime? completedAt;

  const LessonProgress({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.isCompleted,
    required this.watchedDuration,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        studentId,
        lessonId,
        isCompleted,
        watchedDuration,
        completedAt,
      ];
}
