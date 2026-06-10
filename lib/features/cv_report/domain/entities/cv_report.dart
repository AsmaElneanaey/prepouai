import 'package:equatable/equatable.dart';

import 'ai_suggestion.dart';
import 'cv_file_info.dart';
import 'match_score.dart';
import 'skill_breakdown.dart';
import 'work_experience.dart';

export 'ai_suggestion.dart';
export 'cv_file_info.dart';
export 'match_score.dart';
export 'skill_breakdown.dart';
export 'work_experience.dart';

class CvReport extends Equatable {
  const CvReport({
    required this.stageLabel,
    required this.title,
    required this.subtitle,
    required this.file,
    required this.matchScore,
    required this.skills,
    required this.suggestions,
    required this.experiences,
  });

  final String stageLabel;
  final String title;
  final String subtitle;
  final CvFileInfo file;
  final MatchScore matchScore;
  final List<SkillBreakdown> skills;
  final List<AiSuggestion> suggestions;
  final List<WorkExperience> experiences;

  @override
  List<Object?> get props => [
        stageLabel,
        title,
        subtitle,
        file,
        matchScore,
        skills,
        suggestions,
        experiences,
      ];
}
