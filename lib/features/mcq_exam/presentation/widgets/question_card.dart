import 'package:flutter/material.dart';

import '../../domain/entities/mcq_question.dart';
import '../theme/mcq_exam_theme.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question});

  final McqQuestion question;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: McqExamTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: McqExamTheme.borderColor.withValues(alpha: 0.8),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 3,
              width: double.infinity,
              color: McqExamTheme.primaryGreen.withValues(alpha: 0.6),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 16, 17, 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Tag(
                        label: question.category.toUpperCase(),
                        color: McqExamTheme.skillBlue,
                      ),
                      _Tag(
                        label: McqExamTheme.difficultyLabel(question.difficulty).toUpperCase(),
                        color: McqExamTheme.difficultyYellow,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.text,
                    style: const TextStyle(
                      color: McqExamTheme.textPrimary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
