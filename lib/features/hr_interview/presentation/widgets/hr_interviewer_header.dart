import 'package:flutter/material.dart';

import '../../domain/entities/hr_interview_session.dart';
import '../theme/hr_interview_theme.dart';
import 'hr_voice_waveform.dart';

class HrInterviewerHeader extends StatelessWidget {
  const HrInterviewerHeader({super.key, required this.session});

  final HrInterviewSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: HrInterviewTheme.headerCardBg,
        border: Border(
          bottom: BorderSide(color: HrInterviewTheme.borderMuted),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xB330363D),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: HrInterviewTheme.borderMuted),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 11,
                    color: HrInterviewTheme.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    session.headerTimerLabel,
                    style: const TextStyle(
                      color: HrInterviewTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        HrInterviewTheme.accentGreen,
                        HrInterviewTheme.skillBlue.withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: HrInterviewTheme.accentGreen.withValues(alpha: 0.25),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.graphic_eq, color: Colors.black54, size: 36),
                ),
                const SizedBox(height: 12),
                Text(
                  session.interviewerName,
                  style: const TextStyle(
                    color: HrInterviewTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  session.interviewerRole,
                  style: const TextStyle(
                    color: HrInterviewTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                const HrVoiceWaveform(),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
                  decoration: BoxDecoration(
                    color: const Color(0x8030363D),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x9930363D)),
                  ),
                  child: Text(
                    session.liveQuestionCue,
                    style: const TextStyle(
                      color: HrInterviewTheme.textCue,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
