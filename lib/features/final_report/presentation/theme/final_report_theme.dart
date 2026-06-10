import 'package:flutter/material.dart';

class FinalReportTheme {
  static const Color pageBg = Color(0xFF0A0E12);
  static const Color cardBg = Color(0xFF111827);
  static const Color borderMuted = Color(0xCC30363D);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  static const Color accentGreen = Color(0xFF00C896);
  static const Color skillBlue = Color(0xFF4F9CF9);
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderMuted.withValues(alpha: 0.8)),
  );

  static BoxDecoration glassCardDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.12),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.2)),
    // optional blur via BackdropFilter applied elsewhere
  );
}
