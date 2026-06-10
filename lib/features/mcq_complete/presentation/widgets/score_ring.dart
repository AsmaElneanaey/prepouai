import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/mcq_complete_theme.dart';

class ScoreRing extends StatelessWidget {
  const ScoreRing({super.key, required this.scorePercent});

  final int scorePercent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: CustomPaint(
        painter: _ScoreRingPainter(scorePercent: scorePercent),
        child: Center(
          child: Text(
            '$scorePercent%',
            style: const TextStyle(
              color: McqCompleteTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  _ScoreRingPainter({required this.scorePercent});

  final int scorePercent;
  static const int _segments = 32;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 8.0;
    final filledSegments = (scorePercent / 100 * _segments).round();

    for (var i = 0; i < _segments; i++) {
      final startAngle = -math.pi / 2 + (2 * math.pi / _segments) * i;
      final paint = Paint()
        ..color = i < filledSegments
            ? McqCompleteTheme.primaryGreen
            : const Color(0x8030363D)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * math.pi / _segments * 0.75,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.scorePercent != scorePercent;
  }
}
