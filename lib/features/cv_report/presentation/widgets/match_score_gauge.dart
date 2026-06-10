import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/cv_report_theme.dart';

class MatchScoreGauge extends StatelessWidget {
  const MatchScoreGauge({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _GaugePainter(score: score),
        child: Center(
          child: Text(
            '$score',
            style: const TextStyle(
              color: CvReportTheme.primaryGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.score});

  final int score;
  static const int _segments = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 6.0;
    final filledSegments = (score / 100 * _segments).round();

    for (var i = 0; i < _segments; i++) {
      final startAngle = -math.pi / 2 + (2 * math.pi / _segments) * i;
      final paint = Paint()
        ..color = i < filledSegments
            ? CvReportTheme.primaryGreen
            : const Color(0x8030363D)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * math.pi / _segments * 0.7,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.score != score;
  }
}
