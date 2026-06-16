import 'package:equatable/equatable.dart';

class McqCompleteResponse extends Equatable {
  const McqCompleteResponse({
    required this.scorePercent,
    required this.correctCount,
    required this.totalQuestions,
    required this.answeredCount,
  });

  final int scorePercent;
  final int correctCount;
  final int totalQuestions;
  final int answeredCount;

  @override
  List<Object?> get props => [scorePercent, correctCount, totalQuestions, answeredCount];
}

