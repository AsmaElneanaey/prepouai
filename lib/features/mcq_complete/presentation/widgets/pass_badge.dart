import 'package:flutter/material.dart';

import '../theme/mcq_complete_theme.dart';

class PassBadge extends StatelessWidget {
  const PassBadge({super.key, required this.isPass});

  final bool isPass;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: McqCompleteTheme.primaryGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        isPass ? 'PASS' : 'FAIL',
        style: const TextStyle(
          color: McqCompleteTheme.primaryGreen,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
