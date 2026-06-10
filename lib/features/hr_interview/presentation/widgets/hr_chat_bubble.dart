import 'package:flutter/material.dart';

import '../../domain/entities/hr_message.dart';
import '../theme/hr_interview_theme.dart';

class HrChatBubble extends StatelessWidget {
  const HrChatBubble({
    super.key,
    required this.message,
    this.userInitial = 'A',
  });

  final HrInterviewMessage message;
  final String userInitial;

  @override
  Widget build(BuildContext context) {
    final isAi = message.sender == HrMessageSender.ai;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 257),
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
      decoration: BoxDecoration(
        color: isAi ? HrInterviewTheme.aiBubbleBg : HrInterviewTheme.userBubbleFill,
        borderRadius: isAi
            ? const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
        border: Border.all(
          color: isAi
              ? const Color(0x9930363D)
              : HrInterviewTheme.userBubbleBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.body,
            style: const TextStyle(
              color: HrInterviewTheme.textCue,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.timestampLabel,
            style: const TextStyle(
              color: HrInterviewTheme.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );

    final aiAvatar = Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [HrInterviewTheme.accentGreen, HrInterviewTheme.skillBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Text(
        'AI',
        style: TextStyle(
          color: Colors.black,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final userAvatar = Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [HrInterviewTheme.accentGreen, HrInterviewTheme.skillBlue],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        userInitial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (isAi) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: aiAvatar,
          ),
          const SizedBox(width: 8),
          bubble,
          const Spacer(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        bubble,
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: userAvatar,
        ),
      ],
    );
  }
}
