import 'package:flutter/material.dart';

import '../../domain/entities/topic_breakdown.dart';
import '../theme/mcq_complete_theme.dart';

class TopicBreakdownCard extends StatelessWidget {
  const TopicBreakdownCard({super.key, required this.topics});

  final List<TopicBreakdown> topics;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: McqCompleteTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x8030363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOPIC BREAKDOWN',
            style: TextStyle(
              color: McqCompleteTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          ...topics.asMap().entries.map((entry) {
            final topic = entry.value;
            final showDivider = entry.key > 0;
            return Column(
              children: [
                if (showDivider)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0x6630363D),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        topic.name,
                        style: const TextStyle(
                          color: McqCompleteTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${topic.correct}/${topic.total}',
                        style: TextStyle(
                          color: topic.isPerfect
                              ? McqCompleteTheme.primaryGreen
                              : McqCompleteTheme.difficultyYellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
