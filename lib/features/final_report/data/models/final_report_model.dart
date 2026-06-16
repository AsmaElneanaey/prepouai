import '../../domain/entities/final_report.dart';
import '../../../../services/auth_service.dart';

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
    if (json.containsKey('report')) {
      return FinalReportModel.fromApiJson(json, null);
    }

    final list = json['stageScores'] as List<dynamic>? ?? json['stage_scores'] as List<dynamic>? ?? const [];
    final strengthsList = (json['strengths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [];
    final improvementsList = (json['improvements'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [];

    return FinalReportModel(
      overallScore: (json['overallScore'] as num?)?.round() ?? (json['overall_score'] as num?)?.round() ?? 0,
      candidateName: json['candidateName'] as String? ?? json['candidate_name'] as String? ?? '',
      candidateRole: json['candidateRole'] as String? ?? json['candidate_role'] as String? ?? '',
      pipelineDateLabel: json['pipelineDateLabel'] as String? ?? json['pipeline_date_label'] as String? ?? '',
      stageScores: list.map((e) => e as Map<String, dynamic>).toList(),
      strengths: strengthsList,
      improvements: improvementsList,
    );
  }

  factory FinalReportModel.fromApiJson(Map<String, dynamic> json, Map<String, dynamic>? sessionMap) {
    final reportMap = json['report'] as Map<String, dynamic>? ?? {};
    final overallScore = (reportMap['overall_score'] as num?)?.round() ?? 0;

    // candidateName
    final String candidateName;
    if (currentUser.value != null) {
      candidateName = '${currentUser.value!.firstName} ${currentUser.value!.lastName}';
    } else if (reportMap.containsKey('candidate_name')) {
      candidateName = reportMap['candidate_name'] as String;
    } else {
      candidateName = 'Candidate';
    }

    // candidateRole
    final String candidateRole;
    if (sessionMap != null) {
      final role = sessionMap['target_role'] as String? ?? 'Software Engineer';
      final level = sessionMap['seniority_level'] as String? ?? '';
      candidateRole = level.isNotEmpty ? '$level $role' : role;
    } else if (reportMap.containsKey('candidate_role')) {
      candidateRole = reportMap['candidate_role'] as String;
    } else {
      candidateRole = 'Software Engineer';
    }

    // pipelineDateLabel
    String pipelineDateLabel = 'June 16, 2026';
    final dateStr = sessionMap?['started_at'] as String? ?? reportMap['generated_at'] as String?;
    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        final date = DateTime.parse(dateStr);
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        pipelineDateLabel = '${months[date.month - 1]} ${date.day}, ${date.year}';
      } catch (_) {}
    }

    // strengths
    final strengthsList = <String>[];
    final strengthSummary = reportMap['strength_summary'] as String? ?? '';
    if (strengthSummary.isNotEmpty) {
      final sentences = strengthSummary.split('. ');
      for (final sentence in sentences) {
        final clean = sentence.trim().replaceAll(RegExp(r'\.+$'), '');
        if (clean.isNotEmpty) {
          strengthsList.add('$clean.');
        }
      }
    }
    if (strengthsList.isEmpty) {
      strengthsList.add('Strong communication and core engineering skills.');
    }

    // improvements
    final improvementsList = <String>[];
    final areas = reportMap['improvement_areas'] as List<dynamic>?;
    if (areas != null) {
      improvementsList.addAll(areas.map((e) => e.toString()));
    }
    final recommendations = json['recommendations'] as List<dynamic>?;
    if (recommendations != null) {
      for (final rec in recommendations) {
        if (rec is Map) {
          final title = rec['title'] as String? ?? '';
          final desc = rec['description'] as String? ?? '';
          if (title.isNotEmpty) {
            improvementsList.add('$title: $desc');
          }
        }
      }
    }
    if (improvementsList.isEmpty) {
      improvementsList.add('Edge case constraints error handling in coding submissions.');
    }

    // stageScores
    final List<Map<String, dynamic>> stageScores = [];
    if (json.containsKey('stageScores') || json.containsKey('stage_scores')) {
      final list = json['stageScores'] as List<dynamic>? ?? json['stage_scores'] as List<dynamic>? ?? const [];
      stageScores.addAll(list.map((e) => e as Map<String, dynamic>));
    } else if (sessionMap != null) {
      final stages = sessionMap['stages'] as List<dynamic>? ?? const [];
      final cvStage = stages.firstWhere((s) => s is Map && s['stage_type'] == 'cv_upload', orElse: () => null) as Map?;
      final mcqStage = stages.firstWhere((s) => s is Map && s['stage_type'] == 'mcq', orElse: () => null) as Map?;
      final hrStage = stages.firstWhere((s) => s is Map && s['stage_type'] == 'hr_interview', orElse: () => null) as Map?;
      final techStage = stages.firstWhere((s) => s is Map && s['stage_type'] == 'tech_interview', orElse: () => null) as Map?;

      stageScores.add({
        'stageName': 'CV Screening',
        'score': (cvStage?['score'] as num?)?.round() ?? 100,
        'feedback': 'CV parsed successfully. Target role alignment is matched.',
        'iconKey': 'cv',
      });
      stageScores.add({
        'stageName': 'MCQ Exam',
        'score': (mcqStage?['score'] as num?)?.round() ?? 0,
        'feedback': mcqStage?['score'] != null ? 'Scored ${(mcqStage!['score'] as num).round()}% in technical knowledge assessment.' : 'Completed MCQ exam containing core engineering and skill evaluation.',
        'iconKey': 'mcq',
      });
      stageScores.add({
        'stageName': 'HR Behavioral',
        'score': (hrStage?['score'] as num?)?.round() ?? 0,
        'feedback': hrStage?['score'] != null ? 'Scored ${(hrStage!['score'] as num).round()}% in behavioral and communication assessment.' : 'Completed HR behavioral and communication fit assessment.',
        'iconKey': 'hr',
      });
      stageScores.add({
        'stageName': 'Technical Coding',
        'score': (techStage?['score'] as num?)?.round() ?? 0,
        'feedback': techStage?['score'] != null ? 'Scored ${(techStage!['score'] as num).round()}% in live problem-solving and coding challenge.' : 'Completed technical programming and live coding execution.',
        'iconKey': 'tech',
      });
      stageScores.add({
        'stageName': 'Final Assessment',
        'score': overallScore,
        'feedback': 'Final assessment report compiled successfully',
        'iconKey': 'cv',
      });
    } else {
      final readiness = (reportMap['readiness_score'] as num?)?.round() ?? overallScore;
      final technical = (reportMap['technical_score'] as num?)?.round() ?? overallScore;
      final communication = (reportMap['communication_score'] as num?)?.round() ?? overallScore;

      stageScores.add({
        'stageName': 'CV Screening',
        'score': overallScore,
        'feedback': 'CV parsed successfully. Target role alignment is matched.',
        'iconKey': 'cv',
      });
      stageScores.add({
        'stageName': 'MCQ Exam',
        'score': readiness,
        'feedback': 'Completed MCQ exam containing core engineering and skill evaluation.',
        'iconKey': 'mcq',
      });
      stageScores.add({
        'stageName': 'HR Behavioral',
        'score': communication,
        'feedback': 'Completed HR behavioral and communication fit assessment.',
        'iconKey': 'hr',
      });
      stageScores.add({
        'stageName': 'Technical Coding',
        'score': technical,
        'feedback': 'Completed technical programming and live coding execution.',
        'iconKey': 'tech',
      });
      stageScores.add({
        'stageName': 'Final Assessment',
        'score': overallScore,
        'feedback': 'Final assessment report compiled successfully',
        'iconKey': 'cv',
      });
    }

    return FinalReportModel(
      overallScore: overallScore,
      candidateName: candidateName,
      candidateRole: candidateRole,
      pipelineDateLabel: pipelineDateLabel,
      stageScores: stageScores,
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
          score: (s['score'] as num?)?.round() ?? 0,
          feedback: s['feedback'] as String? ?? '',
          iconKey: s['iconKey'] as String? ?? s['icon_key'] as String? ?? '',
        );
      }).toList(),
    );
  }
}
