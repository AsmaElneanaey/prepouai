import 'package:flutter/material.dart';

import '../../domain/entities/mcq_complete_result.dart';
import '../theme/mcq_complete_theme.dart';
import 'continue_hr_cta.dart';
import 'pass_badge.dart';
import 'score_ring.dart';
import 'topic_breakdown_card.dart';

class McqCompleteSheet extends StatelessWidget {
  const McqCompleteSheet({super.key, required this.result});

  final McqCompleteResult result;

  static Future<void> show(BuildContext context, McqCompleteResult result) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => McqCompleteSheet(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: McqCompleteTheme.sheetBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: McqCompleteTheme.borderColor),
              left: BorderSide(color: McqCompleteTheme.borderColor),
              right: BorderSide(color: McqCompleteTheme.borderColor),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xCC30363D),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    ScoreRing(scorePercent: result.scorePercent),
                    const SizedBox(height: 12),
                    PassBadge(isPass: result.isPass),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'MCQ Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: McqCompleteTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'You answered ${result.correctCount} out of ${result.totalCount} correctly',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: McqCompleteTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              TopicBreakdownCard(topics: result.topics),
              const SizedBox(height: 24),
              ContinueHrCta(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/hr-interview');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
