import 'package:flutter/material.dart';

import '../../domain/entities/match_score.dart';
import '../theme/cv_report_theme.dart';
import 'match_score_gauge.dart';

class MatchScoreCard extends StatelessWidget {
  const MatchScoreCard({super.key, required this.matchScore});

  final MatchScore matchScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 17),
      decoration: CvReportTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MATCH SCORE', style: CvReportTheme.sectionLabel),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MatchScoreGauge(score: matchScore.score),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      matchScore.candidateName,
                      style: const TextStyle(
                        color: CvReportTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      matchScore.role,
                      style: const TextStyle(
                        color: CvReportTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      matchScore.experienceLabel,
                      style: const TextStyle(
                        color: CvReportTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          final filled = i < matchScore.filledStars;
                          return Padding(
                            padding: EdgeInsets.only(right: i < 4 ? 2 : 0),
                            child: Icon(
                              filled ? Icons.star : Icons.star_border,
                              size: 12,
                              color: CvReportTheme.starColor,
                            ),
                          );
                        }),
                        const SizedBox(width: 6),
                        Text(
                          matchScore.matchLabel,
                          style: const TextStyle(
                            color: CvReportTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
