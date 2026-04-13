import '../../domain/entities/exam_question.dart';

/// نموذج سؤال الامتحان
class ExamQuestionModel extends ExamQuestion {
  const ExamQuestionModel({
    required super.id,
    required super.examId,
    required super.questionText,
    required super.questionType,
    super.options,
    super.correctAnswer,
    required super.points,
    required super.orderNumber,
    required super.createdAt,
  });

  factory ExamQuestionModel.fromJson(Map<String, dynamic> json) {
    List<String>? options;
    if (json['options'] != null) {
      if (json['options'] is List) {
        options = (json['options'] as List).map((e) => e.toString()).toList();
      }
    }

    return ExamQuestionModel(
      id: json['id'] as String,
      examId: json['exam_id'] as String,
      questionText: json['question_text'] as String,
      questionType: json['question_type'] as String,
      options: options,
      correctAnswer: json['correct_answer'] as String?,
      points: json['points'] as int? ?? 1,
      orderNumber: json['order_number'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_id': examId,
      'question_text': questionText,
      'question_type': questionType,
      'options': options,
      'correct_answer': correctAnswer,
      'points': points,
      'order_number': orderNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ExamQuestionModel copyWith({
    String? id,
    String? examId,
    String? questionText,
    String? questionType,
    List<String>? options,
    String? correctAnswer,
    int? points,
    int? orderNumber,
    DateTime? createdAt,
  }) {
    return ExamQuestionModel(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      points: points ?? this.points,
      orderNumber: orderNumber ?? this.orderNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
