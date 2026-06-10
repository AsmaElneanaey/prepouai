import 'package:flutter/material.dart';

import '../bloc/mcq_exam_state.dart';
import '../theme/mcq_exam_theme.dart';

class ExamProgressHeader extends StatelessWidget {
  const ExamProgressHeader({super.key, required this.state});

  final McqExamInProgress state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Question ${state.currentQuestion.index} of ${state.session.totalQuestions}',
                style: const TextStyle(
                  color: McqExamTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                decoration: BoxDecoration(
                  color: McqExamTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: McqExamTheme.primaryGreen.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 12,
                      color: McqExamTheme.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      state.timerLabel,
                      style: const TextStyle(
                        color: McqExamTheme.primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: McqExamTheme.skillBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${state.answeredCount} / ${state.session.totalQuestions}',
                  style: const TextStyle(
                    color: McqExamTheme.skillBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: state.progressFraction,
                backgroundColor: const Color(0x8030363D),
                valueColor: const AlwaysStoppedAnimation(McqExamTheme.primaryGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
