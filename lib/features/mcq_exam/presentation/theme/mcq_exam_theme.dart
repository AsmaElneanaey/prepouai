import 'package:flutter/material.dart';

import '../../domain/entities/mcq_question.dart';

class McqExamTheme {
  static const Color pageBackground = Color(0xFF0A0E12);
  static const Color cardBackground = Color(0xFF111827);
  static const Color borderColor = Color(0xCC30363D);
  static const Color primaryGreen = Color(0xFF00C896);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  static const Color skillBlue = Color(0xFF4F9CF9);
  static const Color difficultyYellow = Color(0xFFFBBF24);
  static const Color skillRed = Color(0xFFF85149);
  static const Color skillPurple = Color(0xFFA371F7);

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderColor.withValues(alpha: 0.8)),
  );

  static String difficultyLabel(McqDifficulty difficulty) {
    switch (difficulty) {
      case McqDifficulty.easy:
        return 'Easy';
      case McqDifficulty.medium:
        return 'Medium';
      case McqDifficulty.hard:
        return 'Hard';
    }
  }
}
