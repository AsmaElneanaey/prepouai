import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/hr_interview_theme.dart';

/// Static bar waveform matching Figma layout (seven bars).
class HrVoiceWaveform extends StatelessWidget {
  const HrVoiceWaveform({super.key});

  static final List<double> _heights = [2.4, 4.3, 9.6, 2.0, 6.3, 10.9, 3.6];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_heights.length, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < _heights.length - 1 ? 2 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 2,
            height: math.max(_heights[i], 4),
            decoration: BoxDecoration(
              color: HrInterviewTheme.accentGreen,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      }),
    );
  }
}
