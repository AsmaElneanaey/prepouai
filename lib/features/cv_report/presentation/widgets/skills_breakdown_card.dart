import 'package:flutter/material.dart';

import '../../domain/entities/skill_breakdown.dart';
import '../theme/cv_report_theme.dart';

class SkillsBreakdownCard extends StatelessWidget {
  const SkillsBreakdownCard({super.key, required this.skills});

  final List<SkillBreakdown> skills;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 17),
      decoration: CvReportTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SKILLS BREAKDOWN', style: CvReportTheme.sectionLabel),
          const SizedBox(height: 12),
          ...skills.map((skill) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SkillRow(skill: skill),
              )),
        ],
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.skill});

  final SkillBreakdown skill;

  @override
  Widget build(BuildContext context) {
    final color = CvReportTheme.skillColor(skill.barColor);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill.name,
              style: const TextStyle(
                color: CvReportTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${skill.percent}%',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                Container(color: const Color(0x8030363D)),
                FractionallySizedBox(
                  widthFactor: skill.percent / 100,
                  child: Container(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
