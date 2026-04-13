import 'package:equatable/equatable.dart';

/// كيان الامتحان
class Exam extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int totalQuestions;
  final int passingScore;
  final int durationMinutes;
  final String status;
  final bool allowRetake;
  final int maxAttempts;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exam({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.totalQuestions,
    required this.passingScore,
    required this.durationMinutes,
    required this.status,
    required this.allowRetake,
    required this.maxAttempts,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        description,
        totalQuestions,
        passingScore,
        durationMinutes,
        status,
        allowRetake,
        maxAttempts,
        createdAt,
        updatedAt,
      ];
}
