import 'package:equatable/equatable.dart';

/// كيان نتيجة الامتحان
class ExamResult extends Equatable {
  final String id;
  final String examId;
  final String studentId;
  final int score;
  final int totalScore;
  final double percentage;
  final bool passed;
  final int attemptNumber;
  final DateTime? completedAt;
  final Map<String, dynamic>? answers;
  final DateTime createdAt;

  const ExamResult({
    required this.id,
    required this.examId,
    required this.studentId,
    required this.score,
    required this.totalScore,
    required this.percentage,
    required this.passed,
    required this.attemptNumber,
    this.completedAt,
    this.answers,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        examId,
        studentId,
        score,
        totalScore,
        percentage,
        passed,
        attemptNumber,
        completedAt,
        answers,
        createdAt,
      ];
}
