import 'package:equatable/equatable.dart';

/// كيان تقدم التسجيل في الكورس
class EnrollmentProgress extends Equatable {
  final String id;
  final String userId;
  final String courseId;
  final int totalLessons;
  final int completedLessons;
  final int totalDuration; // بالثواني
  final int watchedDuration; // بالثواني
  final DateTime lastAccessedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EnrollmentProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.totalLessons,
    required this.completedLessons,
    required this.totalDuration,
    required this.watchedDuration,
    required this.lastAccessedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        courseId,
        totalLessons,
        completedLessons,
        totalDuration,
        watchedDuration,
        lastAccessedAt,
      ];
}
