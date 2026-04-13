import 'package:equatable/equatable.dart';

/// كيان الامتحان
class Exam extends Equatable {
  final String id;
  final String courseId;
  final String? moduleId; // null = امتحان للكورس بالكامل
  final String title;
  final String? description;
  final int totalQuestions;
  final int passingScore;
  final int durationMinutes;
  final String status;
  final bool allowRetake;
  final int maxAttempts;
  final int orderNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exam({
    required this.id,
    required this.courseId,
    this.moduleId,
    required this.title,
    this.description,
    required this.totalQuestions,
    required this.passingScore,
    required this.durationMinutes,
    required this.status,
    required this.allowRetake,
    required this.maxAttempts,
    this.orderNumber = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// هل الامتحان للكورس بالكامل؟
  bool get isCourseExam => moduleId == null;

  /// هل الامتحان لوحدة معينة؟
  bool get isModuleExam => moduleId != null;

  @override
  List<Object?> get props => [
        id,
        courseId,
        moduleId,
        title,
        description,
        totalQuestions,
        passingScore,
        durationMinutes,
        status,
        allowRetake,
        maxAttempts,
        orderNumber,
        createdAt,
        updatedAt,
      ];
}
