import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/final_report_theme.dart';

class ScoreGauge extends StatelessWidget {
  const ScoreGauge({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 130,
          height: 130,
          child: CustomPaint(
            painter: _FinalGaugePainter(score: score),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$score%',
                    style: const TextStyle(
                      color: FinalReportTheme.accentGreen,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'MATCH SCORE',
                    style: TextStyle(
                      color: FinalReportTheme.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FinalGaugePainter extends CustomPainter {
  _FinalGaugePainter({required this.score});

  final int score;
  static const int _segments = 36;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 8.0;
    final filledSegments = (score / 100 * _segments).round();

    for (var i = 0; i < _segments; i++) {
      final startAngle = -math.pi / 2 + (2 * math.pi / _segments) * i;
      final paint = Paint()
        ..color = i < filledSegments
            ? FinalReportTheme.accentGreen
            : const Color(0xFF1E2633)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * math.pi / _segments * 0.72,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FinalGaugePainter oldDelegate) {
    return oldDelegate.score != score;
  }
}
