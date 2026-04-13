import 'package:equatable/equatable.dart';

/// كيان سؤال الامتحان
class ExamQuestion extends Equatable {
  final String id;
  final String examId;
  final String questionText;
  final String questionType;
  final List<String>? options;
  final String? correctAnswer;
  final int points;
  final int orderNumber;
  final DateTime createdAt;

  const ExamQuestion({
    required this.id,
    required this.examId,
    required this.questionText,
    required this.questionType,
    this.options,
    this.correctAnswer,
    required this.points,
    required this.orderNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        examId,
        questionText,
        questionType,
        options,
        correctAnswer,
        points,
        orderNumber,
        createdAt,
      ];
}
