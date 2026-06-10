import '../../domain/entities/cv_report.dart';

class CvReportModel {
  CvReportModel({
    required this.stageLabel,
    required this.title,
    required this.subtitle,
    required this.fileName,
    required this.fileSizeLabel,
    required this.isParsed,
    required this.matchScore,
    required this.candidateName,
    required this.role,
    required this.experienceLabel,
    required this.filledStars,
    required this.matchLabel,
    required this.skills,
    required this.suggestions,
    required this.experiences,
  });

  final String stageLabel;
  final String title;
  final String subtitle;
  final String fileName;
  final String fileSizeLabel;
  final bool isParsed;
  final int matchScore;
  final String candidateName;
  final String role;
  final String experienceLabel;
  final int filledStars;
  final String matchLabel;
  final List<Map<String, dynamic>> skills;
  final List<String> suggestions;
  final List<Map<String, dynamic>> experiences;

  CvReport toEntity() {
    return CvReport(
      stageLabel: stageLabel,
      title: title,
      subtitle: subtitle,
      file: CvFileInfo(
        fileName: fileName,
        fileSizeLabel: fileSizeLabel,
        isParsed: isParsed,
      ),
      matchScore: MatchScore(
        score: matchScore,
        candidateName: candidateName,
        role: role,
        experienceLabel: experienceLabel,
        filledStars: filledStars,
        matchLabel: matchLabel,
      ),
      skills: skills.map((s) {
        return SkillBreakdown(
          name: s['name'] as String,
          percent: s['percent'] as int,
          barColor: SkillBarColor.values.byName(s['barColor'] as String),
        );
      }).toList(),
      suggestions: suggestions.map((m) => AiSuggestion(message: m)).toList(),
      experiences: experiences.asMap().entries.map((entry) {
        final e = entry.value;
        return WorkExperience(
          title: e['title'] as String,
          company: e['company'] as String,
          period: e['period'] as String,
          description: e['description'] as String,
          isLast: entry.key == experiences.length - 1,
        );
      }).toList(),
    );
  }
}
