import 'package:equatable/equatable.dart';

class MasterQuestion extends Equatable {
  const MasterQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.isAiGenerated,
    required this.estimatedTimeSec,
  });

  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String category;
  final String difficulty;
  final List<String> tags;
  final bool isAiGenerated;
  final int estimatedTimeSec;

  @override
  List<Object?> get props => [
        id,
        questionText,
        options,
        correctOptionIndex,
        category,
        difficulty,
        tags,
        isAiGenerated,
        estimatedTimeSec,
      ];
}
