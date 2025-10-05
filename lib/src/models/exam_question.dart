import 'package:equatable/equatable.dart';

class ExamQuestion extends Equatable {
  final int id;
  final String text;
  final List<String> options;
  final int correctAnswer;

  const ExamQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  ExamQuestion copyWith({
    int? id,
    String? text,
    List<String>? options,
    int? correctAnswer,
  }) {
    return ExamQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        options,
        correctAnswer,
      ];
}
