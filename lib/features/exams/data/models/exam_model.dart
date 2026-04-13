import '../../domain/entities/exam.dart';

/// نموذج الامتحان
class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.courseId,
    required super.title,
    super.description,
    required super.totalQuestions,
    required super.passingScore,
    required super.durationMinutes,
    required super.status,
    required super.allowRetake,
    required super.maxAttempts,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      totalQuestions: json['total_questions'] as int? ?? 0,
      passingScore: json['passing_score'] as int? ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      status: json['status'] as String? ?? 'draft',
      allowRetake: json['allow_retake'] as bool? ?? true,
      maxAttempts: json['max_attempts'] as int? ?? 3,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'total_questions': totalQuestions,
      'passing_score': passingScore,
      'duration_minutes': durationMinutes,
      'status': status,
      'allow_retake': allowRetake,
      'max_attempts': maxAttempts,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ExamModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    int? totalQuestions,
    int? passingScore,
    int? durationMinutes,
    String? status,
    bool? allowRetake,
    int? maxAttempts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExamModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      passingScore: passingScore ?? this.passingScore,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      allowRetake: allowRetake ?? this.allowRetake,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
