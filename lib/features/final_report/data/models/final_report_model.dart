import '../../domain/entities/final_report.dart';

class FinalReportModel {
  FinalReportModel({
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
  final List<Map<String, dynamic>> stageScores;
  final List<String> strengths;
  final List<String> improvements;

  FinalReport toEntity() {
    return FinalReport(
      overallScore: overallScore,
      candidateName: candidateName,
      candidateRole: candidateRole,
      pipelineDateLabel: pipelineDateLabel,
      strengths: strengths,
      improvements: improvements,
      stageScores: stageScores.map((s) {
        return StageScore(
          stageName: s['stageName'] as String,
          score: s['score'] as int,
          feedback: s['feedback'] as String,
          iconKey: s['iconKey'] as String,
        );
      }).toList(),
    );
  }
}
