import 'package:flutter/material.dart';

import '../theme/mcq_exam_theme.dart';

class ExamNavigationBar extends StatelessWidget {
  const ExamNavigationBar({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.showFinish,
    required this.canFinish,
    required this.onPrevious,
    required this.onNext,
    required this.onFinish,
  });

  final bool canGoPrevious;
  final bool canGoNext;
  final bool showFinish;
  final bool canFinish;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x6630363D))),
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavButton(
              label: 'Previous',
              icon: Icons.chevron_left,
              iconOnLeft: true,
              enabled: canGoPrevious,
              isPrimary: false,
              onTap: onPrevious,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: showFinish
                ? _NavButton(
                    label: 'Finish',
                    icon: Icons.chevron_right,
                    iconOnLeft: false,
                    enabled: canFinish,
                    isPrimary: true,
                    onTap: onFinish,
                  )
                : _NavButton(
                    label: 'Next',
                    icon: Icons.chevron_right,
                    iconOnLeft: false,
                    enabled: canGoNext,
                    isPrimary: false,
                    onTap: onNext,
                  ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.iconOnLeft,
    required this.enabled,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool iconOnLeft;
  final bool enabled;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    final Color bgColor;

    if (isPrimary && enabled) {
      textColor = McqExamTheme.pageBackground;
      bgColor = McqExamTheme.primaryGreen;
    } else if (enabled) {
      textColor = McqExamTheme.textPrimary;
      bgColor = const Color(0x6630363D);
    } else {
      textColor = McqExamTheme.textMuted;
      bgColor = const Color(0x6630363D);
    }

    final child = Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: isPrimary
                ? null
                : Border.all(
                    color: McqExamTheme.borderColor.withValues(alpha: 0.8),
                  ),
            boxShadow: isPrimary && enabled
                ? [
                    BoxShadow(
                      color: McqExamTheme.primaryGreen.withValues(alpha: 0.25),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            height: 47,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconOnLeft) ...[
                  Icon(icon, size: 16, color: textColor),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight:
                        iconOnLeft ? FontWeight.w500 : FontWeight.w600,
                  ),
                ),
                if (!iconOnLeft) ...[
                  const SizedBox(width: 4),
                  Icon(icon, size: 16, color: textColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return Opacity(opacity: enabled ? 1 : 0.6, child: child);
  }
}
