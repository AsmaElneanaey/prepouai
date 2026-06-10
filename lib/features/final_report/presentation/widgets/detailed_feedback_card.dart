import 'package:flutter/material.dart';

import '../theme/final_report_theme.dart';

class DetailedFeedbackCard extends StatelessWidget {
  const DetailedFeedbackCard({
    super.key,
    required this.strengths,
    required this.improvements,
  });

  final List<String> strengths;
  final List<String> improvements;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: FinalReportTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Strengths Section
          const Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, color: FinalReportTheme.accentGreen, size: 16),
              SizedBox(width: 8),
              Text(
                'KEY STRENGTHS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...strengths.map(
            (str) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: FinalReportTheme.accentGreen,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      str,
                      style: const TextStyle(
                        color: FinalReportTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: FinalReportTheme.borderMuted),
          ),

          // Improvement Section
          const Row(
            children: [
              Icon(Icons.trending_up_rounded, color: Color(0xFFFBBF24), size: 16),
              SizedBox(width: 8),
              Text(
                'AREAS TO IMPROVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...improvements.map(
            (imp) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFFBBF24),
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      imp,
                      style: const TextStyle(
                        color: FinalReportTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
