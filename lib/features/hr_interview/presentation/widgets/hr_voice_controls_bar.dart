import 'package:flutter/material.dart';

import '../theme/hr_interview_theme.dart';
import 'hr_complete_sheet.dart';

class HrVoiceControlsBar extends StatelessWidget {
  const HrVoiceControlsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 13, 20, 12),
      decoration: const BoxDecoration(
        color: HrInterviewTheme.controlsBarBg,
        border: Border(
          top: BorderSide(color: HrInterviewTheme.borderMuted),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CircleButton(
              size: 48,
              bg: HrInterviewTheme.endCallRed,
              child: Icon(
                Icons.call_end_rounded,
                color: Colors.white.withValues(alpha: 0.95),
                size: 20,
              ),
              onTap: () {
                HrCompleteSheet.show(context);
              },
            ),
            _CircleButton(
              size: 48,
              bg: HrInterviewTheme.accentGreen.withValues(alpha: 0.15),
              borderWidth: 1,
              borderColor: HrInterviewTheme.accentGreen.withValues(alpha: 0.35),
              boxShadow: BoxShadow(
                color: HrInterviewTheme.accentGreen.withValues(alpha: 0.2),
                blurRadius: 16,
              ),
              child: Icon(
                Icons.mic_rounded,
                color: HrInterviewTheme.accentGreen,
                size: 22,
              ),
              onTap: () {},
            ),
            _mutedIconButton(Icons.volume_up_rounded),
            _mutedIconButton(Icons.chat_bubble_outline_rounded),
            _mutedIconButton(Icons.open_in_full_rounded, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _mutedIconButton(IconData icon, {double size = 40}) {
    return _CircleButton(
      size: size,
      bg: const Color(0x8030363D),
      child: Icon(icon, color: HrInterviewTheme.textSecondary, size: 16),
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
