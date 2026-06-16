import 'package:equatable/equatable.dart';

class McqAnswerResponse extends Equatable {
  const McqAnswerResponse({
    required this.isCorrect,
    required this.explanation,
  });

  final bool isCorrect;
  final String explanation;

  @override
  List<Object?> get props => [isCorrect, explanation];
}
