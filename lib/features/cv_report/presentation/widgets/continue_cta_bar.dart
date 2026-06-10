import 'package:flutter/material.dart';

import '../theme/cv_report_theme.dart';

class ContinueCtaBar extends StatelessWidget {
  const ContinueCtaBar({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      decoration: const BoxDecoration(
        color: CvReportTheme.pageBackground,
        border: Border(
          top: BorderSide(color: Color(0x6630363D)),
        ),
      ),
      child: Material(
        color: CvReportTheme.primaryGreen,
        borderRadius: BorderRadius.circular(14),
        elevation: 0,
        shadowColor: CvReportTheme.primaryGreen.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onPressed ??
              () {
                Navigator.pushNamed(context, '/mcq-exam');
              },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: CvReportTheme.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue to MCQ Exam',
                  style: TextStyle(
                    color: CvReportTheme.pageBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: CvReportTheme.pageBackground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
