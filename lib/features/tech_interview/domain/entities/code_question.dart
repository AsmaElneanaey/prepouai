import 'package:equatable/equatable.dart';

enum TechDifficulty { easy, medium, hard }

class CodeQuestion extends Equatable {
  const CodeQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.starterCode,
    required this.language,
  });

  final String id;
  final String title;
  final String description;
  final TechDifficulty difficulty;
  final String starterCode;
  final String language;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        difficulty,
        starterCode,
        language,
      ];
}
