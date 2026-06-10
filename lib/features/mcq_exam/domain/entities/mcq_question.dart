import 'package:equatable/equatable.dart';

import 'mcq_option.dart';

enum McqDifficulty { easy, medium, hard }

class McqQuestion extends Equatable {
  const McqQuestion({
    required this.index,
    required this.category,
    required this.difficulty,
    required this.text,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
  });

  final int index;
  final String category;
  final McqDifficulty difficulty;
  final String text;
  final List<McqOption> options;
  final String correctOptionId;
  final String explanation;

  @override
  List<Object?> get props => [
        index,
        category,
        difficulty,
        text,
        options,
        correctOptionId,
        explanation,
      ];
}
