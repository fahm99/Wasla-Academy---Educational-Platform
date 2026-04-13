import '../../domain/entities/exam_result.dart';

/// نموذج نتيجة الامتحان
class ExamResultModel extends ExamResult {
  const ExamResultModel({
    required super.id,
    required super.examId,
    required super.studentId,
    required super.score,
    required super.totalScore,
    required super.percentage,
    required super.passed,
    required super.attemptNumber,
    super.completedAt,
    super.answers,
    required super.createdAt,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      id: json['id'] as String,
      examId: json['exam_id'] as String,
      studentId: json['student_id'] as String,
      score: json['score'] as int? ?? 0,
      totalScore: json['total_score'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      passed: json['passed'] as bool? ?? false,
      attemptNumber: json['attempt_number'] as int? ?? 1,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      answers: json['answers'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_id': examId,
      'student_id': studentId,
      'score': score,
      'total_score': totalScore,
      'percentage': percentage,
      'passed': passed,
      'attempt_number': attemptNumber,
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
      'answers': answers,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ExamResultModel copyWith({
    String? id,
    String? examId,
    String? studentId,
    int? score,
    int? totalScore,
    double? percentage,
    bool? passed,
    int? attemptNumber,
    DateTime? completedAt,
    Map<String, dynamic>? answers,
    DateTime? createdAt,
  }) {
    return ExamResultModel(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      studentId: studentId ?? this.studentId,
      score: score ?? this.score,
      totalScore: totalScore ?? this.totalScore,
      percentage: percentage ?? this.percentage,
      passed: passed ?? this.passed,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      completedAt: completedAt ?? this.completedAt,
      answers: answers ?? this.answers,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
