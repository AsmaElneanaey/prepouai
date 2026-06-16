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

  factory FinalReportModel.fromJson(Map<String, dynamic> json) {
    final list = json['stageScores'] as List<dynamic>? ?? json['stage_scores'] as List<dynamic>? ?? const [];
    final strengthsList = (json['strengths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [];
    final improvementsList = (json['improvements'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [];

    return FinalReportModel(
      overallScore: json['overallScore'] as int? ?? json['overall_score'] as int? ?? 0,
      candidateName: json['candidateName'] as String? ?? json['candidate_name'] as String? ?? '',
      candidateRole: json['candidateRole'] as String? ?? json['candidate_role'] as String? ?? '',
      pipelineDateLabel: json['pipelineDateLabel'] as String? ?? json['pipeline_date_label'] as String? ?? '',
      stageScores: list.map((e) => e as Map<String, dynamic>).toList(),
      strengths: strengthsList,
      improvements: improvementsList,
    );
  }

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
          stageName: s['stageName'] as String? ?? s['stage_name'] as String? ?? '',
          score: s['score'] as int? ?? 0,
          feedback: s['feedback'] as String? ?? '',
          iconKey: s['iconKey'] as String? ?? s['icon_key'] as String? ?? '',
        );
      }).toList(),
    );
  }
}
