import 'package:flutter/material.dart';

import '../../domain/entities/stage_score.dart';
import '../theme/final_report_theme.dart';

class StageScoresBreakdown extends StatelessWidget {
  const StageScoresBreakdown({super.key, required this.scores});

  final List<StageScore> scores;

  IconData _getIcon(String iconKey) {
    switch (iconKey) {
      case 'cv':
        return Icons.description_outlined;
      case 'mcq':
        return Icons.quiz_outlined;
      case 'hr':
        return Icons.people_outline_rounded;
      case 'tech':
        return Icons.code_rounded;
      default:
        return Icons.star_border_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STAGE BREAKDOWNS',
          style: TextStyle(
            color: FinalReportTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scores.length,
          separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
          itemBuilder: (ctx, index) {
            final stage = scores[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: FinalReportTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: FinalReportTheme.borderMuted.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIcon(stage.iconKey),
                          color: FinalReportTheme.accentGreen,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stage.stageName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Stage ${index + 1} of 5',
                              style: const TextStyle(
                                color: FinalReportTheme.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${stage.score}%',
                        style: const TextStyle(
                          color: FinalReportTheme.accentGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: stage.score / 100,
                      backgroundColor: const Color(0xFF1E2633),
                      color: FinalReportTheme.accentGreen,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stage.feedback,
                    style: const TextStyle(
                      color: FinalReportTheme.textSecondary,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
