import 'package:equatable/equatable.dart';

class MatchScore extends Equatable {
  const MatchScore({
    required this.score,
    required this.candidateName,
    required this.role,
    required this.experienceLabel,
    required this.filledStars,
    required this.matchLabel,
  });

  final int score;
  final String candidateName;
  final String role;
  final String experienceLabel;
  final int filledStars;
  final String matchLabel;

  @override
  List<Object?> get props => [
        score,
        candidateName,
        role,
        experienceLabel,
        filledStars,
        matchLabel,
      ];
}
