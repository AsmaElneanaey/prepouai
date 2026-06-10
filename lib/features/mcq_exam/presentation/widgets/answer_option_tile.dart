import 'package:flutter/material.dart';

import '../../domain/entities/mcq_option.dart';
import '../theme/mcq_exam_theme.dart';

enum AnswerOptionVisualState {
  idle,
  selected,
  selectedCorrect,
  selectedWrong,
  disabled,
}

class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    super.key,
    required this.option,
    required this.visualState,
    required this.onTap,
  });

  final McqOption option;
  final AnswerOptionVisualState visualState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isInteractive = visualState == AnswerOptionVisualState.idle ||
        visualState == AnswerOptionVisualState.selected;

    Color borderColor;
    Color bgColor;
    Color letterBg;
    Color letterColor;
    Color labelColor;
    Widget? trailing;

    switch (visualState) {
      case AnswerOptionVisualState.selectedCorrect:
        borderColor = McqExamTheme.primaryGreen;
        bgColor = McqExamTheme.primaryGreen.withValues(alpha: 0.12);
        letterBg = McqExamTheme.primaryGreen;
        letterColor = McqExamTheme.pageBackground;
        labelColor = McqExamTheme.primaryGreen;
        trailing = const Icon(Icons.check, size: 12, color: McqExamTheme.pageBackground);
      case AnswerOptionVisualState.selectedWrong:
        borderColor = McqExamTheme.skillRed;
        bgColor = McqExamTheme.skillRed.withValues(alpha: 0.08);
        letterBg = McqExamTheme.skillRed.withValues(alpha: 0.2);
        letterColor = McqExamTheme.skillRed;
        labelColor = McqExamTheme.skillRed;
      case AnswerOptionVisualState.disabled:
        borderColor = McqExamTheme.borderColor.withValues(alpha: 0.4);
        bgColor = McqExamTheme.cardBackground;
        letterBg = const Color(0x8030363D);
        letterColor = McqExamTheme.textSecondary;
        labelColor = McqExamTheme.textMuted;
      case AnswerOptionVisualState.selected:
        borderColor = McqExamTheme.primaryGreen.withValues(alpha: 0.6);
        bgColor = McqExamTheme.cardBackground;
        letterBg = McqExamTheme.primaryGreen.withValues(alpha: 0.2);
        letterColor = McqExamTheme.primaryGreen;
        labelColor = McqExamTheme.textPrimary;
      case AnswerOptionVisualState.idle:
        borderColor = McqExamTheme.borderColor.withValues(alpha: 0.8);
        bgColor = McqExamTheme.cardBackground;
        letterBg = const Color(0x8030363D);
        letterColor = McqExamTheme.textSecondary;
        labelColor = McqExamTheme.textPrimary;
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: isInteractive ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: visualState == AnswerOptionVisualState.selectedCorrect ? 1.5 : 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: letterBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: trailing ??
                      Text(
                        option.id,
                        style: TextStyle(
                          color: letterColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.label,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 13,
                      fontWeight: visualState == AnswerOptionVisualState.selectedCorrect ||
                              visualState == AnswerOptionVisualState.selected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
