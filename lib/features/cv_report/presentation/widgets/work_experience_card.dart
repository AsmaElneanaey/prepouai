import 'package:flutter/material.dart';

import '../../domain/entities/work_experience.dart';
import '../theme/cv_report_theme.dart';

class WorkExperienceCard extends StatelessWidget {
  const WorkExperienceCard({super.key, required this.experiences});

  final List<WorkExperience> experiences;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 17),
      decoration: CvReportTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WORK EXPERIENCE', style: CvReportTheme.sectionLabel),
          const SizedBox(height: 12),
          ...experiences.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ExperienceRow(experience: e),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
  const _ExperienceRow({required this.experience});

  final WorkExperience experience;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: CvReportTheme.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!experience.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color(0x8030363D),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.title,
                  style: const TextStyle(
                    color: CvReportTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  experience.company,
                  style: const TextStyle(
                    color: CvReportTheme.primaryGreen,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  experience.period,
                  style: const TextStyle(
                    color: CvReportTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  experience.description,
                  style: const TextStyle(
                    color: CvReportTheme.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
