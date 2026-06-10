import 'package:flutter/material.dart';

import '../theme/mcq_exam_theme.dart';

class AnswerFeedbackCard extends StatelessWidget {
  const AnswerFeedbackCard({
    super.key,
    required this.isCorrect,
    required this.explanation,
  });

  final bool isCorrect;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: isCorrect
            ? McqExamTheme.primaryGreen.withValues(alpha: 0.06)
            : McqExamTheme.skillRed.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCorrect
              ? McqExamTheme.primaryGreen.withValues(alpha: 0.2)
              : McqExamTheme.skillRed.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? '✓ Correct!' : '✗ Incorrect',
            style: TextStyle(
              color: isCorrect
                  ? McqExamTheme.primaryGreen
                  : McqExamTheme.skillRed,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            explanation,
            style: const TextStyle(
              color: McqExamTheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
