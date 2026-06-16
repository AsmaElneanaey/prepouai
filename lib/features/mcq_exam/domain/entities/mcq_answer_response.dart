import 'package:equatable/equatable.dart';

class McqAnswerResponse extends Equatable {
  const McqAnswerResponse({
    required this.isCorrect,
    required this.explanation,
    this.correctOptionIndex,
  });

  final bool isCorrect;
  final String explanation;
  final int? correctOptionIndex;

  @override
  List<Object?> get props => [isCorrect, explanation, correctOptionIndex];
}

