import 'package:flutter/material.dart';

import '../theme/hr_interview_theme.dart';

class HrCompleteSheet extends StatelessWidget {
  const HrCompleteSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => const HrCompleteSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.35,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: HrInterviewTheme.aiBubbleBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: HrInterviewTheme.borderMuted),
              left: BorderSide(color: HrInterviewTheme.borderMuted),
              right: BorderSide(color: HrInterviewTheme.borderMuted),
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
                    color: HrInterviewTheme.borderMuted,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: HrInterviewTheme.accentGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: HrInterviewTheme.accentGreen.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: HrInterviewTheme.accentGreen,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'HR Interview Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HrInterviewTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your behavioral round responses have been successfully recorded and analyzed by AI. You are now ready to continue to the technical coding round.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HrInterviewTheme.textSecondary,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              
              // Continue CTA button
              Material(
                color: HrInterviewTheme.accentGreen,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // dismiss sheet
                    Navigator.of(context).pushReplacementNamed('/tech-interview');
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Tech Interview',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
