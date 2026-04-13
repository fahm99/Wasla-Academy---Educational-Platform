import '../../domain/entities/lesson_progress.dart';

/// نموذج تقدم الدرس
class LessonProgressModel extends LessonProgress {
  const LessonProgressModel({
    required super.id,
    required super.studentId,
    required super.lessonId,
    required super.isCompleted,
    required super.watchedDuration,
    super.completedAt,
  });

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      lessonId: json['lesson_id'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      watchedDuration: json['watched_duration'] as int? ?? 0,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'lesson_id': lessonId,
      'is_completed': isCompleted,
      'watched_duration': watchedDuration,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  LessonProgressModel copyWith({
    String? id,
    String? studentId,
    String? lessonId,
    bool? isCompleted,
    int? watchedDuration,
    DateTime? completedAt,
  }) {
    return LessonProgressModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      watchedDuration: watchedDuration ?? this.watchedDuration,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
