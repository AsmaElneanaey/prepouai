import 'package:flutter/material.dart';

import '../../domain/entities/skill_breakdown.dart';

class CvReportTheme {
  static const Color pageBackground = Color(0xFF0A0E12);
  static const Color cardBackground = Color(0xFF111827);
  static const Color borderColor = Color(0xCC30363D);
  static const Color primaryGreen = Color(0xFF00C896);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  static const Color suggestionText = Color(0xFFC9D1D9);
  static const Color starColor = Color(0xFFFBBF24);

  static const Color skillBlue = Color(0xFF4F9CF9);
  static const Color skillPurple = Color(0xFFA371F7);
  static const Color skillYellow = Color(0xFFFBBF24);
  static const Color skillRed = Color(0xFFF85149);

  static Color skillColor(SkillBarColor color) {
    switch (color) {
      case SkillBarColor.blue:
        return skillBlue;
      case SkillBarColor.green:
        return primaryGreen;
      case SkillBarColor.purple:
        return skillPurple;
      case SkillBarColor.yellow:
        return skillYellow;
      case SkillBarColor.red:
        return skillRed;
    }
  }

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderColor.withValues(alpha: 0.8)),
  );

  static TextStyle sectionLabel = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: textMuted,
  );
}
