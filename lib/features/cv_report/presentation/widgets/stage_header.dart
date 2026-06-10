import 'package:flutter/material.dart';

import '../../domain/entities/cv_report.dart';
import '../theme/cv_report_theme.dart';

class StageHeader extends StatelessWidget {
  const StageHeader({super.key, required this.report});

  final CvReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: CvReportTheme.primaryGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: CvReportTheme.primaryGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            report.stageLabel.toUpperCase(),
            style: const TextStyle(
              color: CvReportTheme.primaryGreen,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          report.title,
          style: const TextStyle(
            color: CvReportTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          report.subtitle,
          style: const TextStyle(
            color: CvReportTheme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
