import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/tech_interview_theme.dart';
import '../bloc/tech_interview_bloc.dart';
import '../bloc/tech_interview_event.dart';

class TechVoiceControlsBar extends StatelessWidget {
  const TechVoiceControlsBar({
    super.key,
    required this.isSuccess,
    required this.isSubmitting,
  });

  final bool isSuccess;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 13, 20, 12),
      decoration: const BoxDecoration(
        color: TechInterviewTheme.controlsBarBg,
        border: Border(
          top: BorderSide(color: TechInterviewTheme.borderMuted),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // End Call Red Button
            _CircleButton(
              size: 48,
              bg: TechInterviewTheme.endCallRed,
              child: const Icon(
                Icons.call_end_rounded,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/final-report');
              },
            ),

            // Mic toggle
            _CircleButton(
              size: 48,
              bg: TechInterviewTheme.accentGreen.withValues(alpha: 0.15),
              borderWidth: 1,
              borderColor: TechInterviewTheme.accentGreen.withValues(alpha: 0.35),
              boxShadow: BoxShadow(
                color: TechInterviewTheme.accentGreen.withValues(alpha: 0.2),
                blurRadius: 16,
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: TechInterviewTheme.accentGreen,
                size: 22,
              ),
              onTap: () {},
            ),

            _mutedIconButton(Icons.volume_up_rounded),
            _mutedIconButton(Icons.open_in_full_rounded, size: 40),

            // Submit / Action Button
            isSuccess
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TechInterviewTheme.accentGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/final-report');
                    },
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text(
                      'Final Report',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  )
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSubmitting
                          ? Colors.grey.shade800
                          : TechInterviewTheme.accentGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isSubmitting
                        ? null
                        : () {
                            context.read<TechInterviewBloc>().add(const SubmitCodePressed());
                          },
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                          )
                        : const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text(
                      'Run Code',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _mutedIconButton(IconData icon, {double size = 40}) {
    return _CircleButton(
      size: size,
      bg: const Color(0x8030363D),
      child: Icon(icon, color: TechInterviewTheme.textSecondary, size: 16),
      onTap: () {},
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.size,
    required this.bg,
    required this.child,
    required this.onTap,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.boxShadow,
  });

  final double size;
  final Color bg;
  final Widget child;
  final VoidCallback onTap;
  final double borderWidth;
  final Color borderColor;
  final BoxShadow? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bg,
            border: borderWidth > 0
                ? Border.all(width: borderWidth, color: borderColor)
                : null,
            boxShadow: boxShadow != null ? [boxShadow!] : null,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
