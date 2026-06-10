import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tech_interview_session.dart';
import '../theme/tech_interview_theme.dart';
import '../bloc/tech_interview_bloc.dart';
import '../bloc/tech_interview_event.dart';

class TechChatPanel extends StatefulWidget {
  const TechChatPanel({super.key, required this.session});

  final TechInterviewSession session;

  @override
  State<TechChatPanel> createState() => _TechChatPanelState();
}

class _TechChatPanelState extends State<TechChatPanel> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isNotEmpty) {
      context.read<TechInterviewBloc>().add(SendMessagePressed(text));
      _msgController.clear();
      // Scroll down
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TechInterviewTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TechInterviewTheme.borderMuted.withValues(alpha: 0.8)),
      ),
      child: Column(
        children: [
          // Chat title header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: TechInterviewTheme.borderMuted),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.chat_bubble_outline_rounded, color: TechInterviewTheme.accentGreen, size: 16),
                SizedBox(width: 8),
                Text(
                  'AI DISCUSSION',
                  style: TextStyle(
                    color: TechInterviewTheme.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Message history
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.session.messages.length,
              separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
              itemBuilder: (ctx, index) {
                final msg = widget.session.messages[index];
                return _TechChatBubble(message: msg);
              },
            ),
          ),

          // Message input bar
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: TechInterviewTheme.borderMuted),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x8030363D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _msgController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Ask the AI coach for hints...',
                        hintStyle: TextStyle(color: TechInterviewTheme.textMuted),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: TechInterviewTheme.accentGreen),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChatBubble extends StatelessWidget {
  const _TechChatBubble({required this.message});

  final TechChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isAi = message.sender == TechMessageSender.ai;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: isAi ? TechInterviewTheme.aiBubbleBg : TechInterviewTheme.userBubbleFill,
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
              : TechInterviewTheme.userBubbleBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.body,
            style: const TextStyle(
              color: TechInterviewTheme.textPrimary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.timestampLabel,
            style: const TextStyle(
              color: TechInterviewTheme.textMuted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );

    final aiAvatar = Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [TechInterviewTheme.accentGreen, Colors.blueAccent],
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
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [TechInterviewTheme.accentGreen, Colors.blueAccent],
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'U',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (isAi) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          aiAvatar,
          const SizedBox(width: 8),
          bubble,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        bubble,
        const SizedBox(width: 8),
        userAvatar,
      ],
    );
  }
}
