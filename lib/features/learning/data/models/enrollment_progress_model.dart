import '../../domain/entities/enrollment_progress.dart';

/// نموذج تقدم التسجيل في الكورس
class EnrollmentProgressModel extends EnrollmentProgress {
  const EnrollmentProgressModel({
    required super.id,
    required super.userId,
    required super.courseId,
    required super.totalLessons,
    required super.completedLessons,
    required super.totalDuration,
    required super.watchedDuration,
    required super.lastAccessedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory EnrollmentProgressModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentProgressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      totalLessons: json['total_lessons'] as int? ?? 0,
      completedLessons: json['completed_lessons'] as int? ?? 0,
      totalDuration: json['total_duration'] as int? ?? 0,
      watchedDuration: json['watched_duration'] as int? ?? 0,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.parse(json['last_accessed_at'] as String)
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'total_lessons': totalLessons,
      'completed_lessons': completedLessons,
      'total_duration': totalDuration,
      'watched_duration': watchedDuration,
      'last_accessed_at': lastAccessedAt.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  double get progressPercentage {
    if (totalLessons == 0) return 0.0;
    return (completedLessons / totalLessons * 100).clamp(0.0, 100.0);
  }

  bool get isCompleted => completedLessons >= totalLessons && totalLessons > 0;
}
