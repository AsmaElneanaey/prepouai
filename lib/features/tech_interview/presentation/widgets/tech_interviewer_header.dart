import 'package:flutter/material.dart';

import '../../domain/entities/tech_interview_session.dart';
import '../theme/tech_interview_theme.dart';
import '../../../hr_interview/presentation/widgets/hr_voice_waveform.dart';

class TechInterviewerHeader extends StatelessWidget {
  const TechInterviewerHeader({super.key, required this.session});

  final TechInterviewSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: TechInterviewTheme.headerCardBg,
        border: Border(
          bottom: BorderSide(color: TechInterviewTheme.borderMuted),
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
                border: Border.all(color: TechInterviewTheme.borderMuted),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 11,
                    color: TechInterviewTheme.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    session.headerTimerLabel,
                    style: const TextStyle(
                      color: TechInterviewTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        TechInterviewTheme.accentGreen,
                        Colors.blueAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: TechInterviewTheme.accentGreen.withValues(alpha: 0.25),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.code, color: Colors.black54, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.interviewerName,
                        style: const TextStyle(
                          color: TechInterviewTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        session.interviewerRole,
                        style: const TextStyle(
                          color: TechInterviewTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 60,
                  height: 30,
                  child: HrVoiceWaveform(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
