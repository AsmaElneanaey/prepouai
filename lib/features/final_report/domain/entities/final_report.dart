import 'package:equatable/equatable.dart';

import 'stage_score.dart';

export 'stage_score.dart';

class FinalReport extends Equatable {
  const FinalReport({
    required this.overallScore,
    required this.candidateName,
    required this.candidateRole,
    required this.pipelineDateLabel,
    required this.stageScores,
    required this.strengths,
    required this.improvements,
  });

  final int overallScore;
  final String candidateName;
  final String candidateRole;
  final String pipelineDateLabel;
  final List<StageScore> stageScores;
  final List<String> strengths;
  final List<String> improvements;

  @override
  List<Object?> get props => [
        overallScore,
        candidateName,
        candidateRole,
        pipelineDateLabel,
        stageScores,
        strengths,
        improvements,
      ];
}
