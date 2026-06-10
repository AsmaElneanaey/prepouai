import 'package:flutter/material.dart';

import '../../domain/entities/cv_file_info.dart';
import '../theme/cv_report_theme.dart';

class CvFileCard extends StatelessWidget {
  const CvFileCard({super.key, required this.file});

  final CvFileInfo file;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: CvReportTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CvReportTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: CvReportTheme.primaryGreen,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName,
                  style: const TextStyle(
                    color: CvReportTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  file.fileSizeLabel,
                  style: const TextStyle(
                    color: CvReportTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (file.isParsed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CvReportTheme.primaryGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: CvReportTheme.primaryGreen.withValues(alpha: 0.25),
                ),
              ),
              child: const Text(
                'Parsed ✓',
                style: TextStyle(
                  color: CvReportTheme.primaryGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
