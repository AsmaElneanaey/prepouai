import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/tech_interview_theme.dart';
import '../bloc/tech_interview_bloc.dart';
import '../bloc/tech_interview_event.dart';

class CodeEditorCard extends StatefulWidget {
  const CodeEditorCard({
    super.key,
    required this.code,
    required this.language,
    required this.terminalOutput,
    required this.isSubmitting,
  });

  final String code;
  final String language;
  final String terminalOutput;
  final bool isSubmitting;

  @override
  State<CodeEditorCard> createState() => _CodeEditorCardState();
}

class _CodeEditorCardState extends State<CodeEditorCard> {
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.code);
    _codeController.addListener(_onCodeChanged);
  }

  @override
  void didUpdateWidget(covariant CodeEditorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code && _codeController.text != widget.code) {
      _codeController.text = widget.code;
    }
  }

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    context.read<TechInterviewBloc>().add(CodeChanged(_codeController.text));
    setState(() {}); // refresh line numbers
  }

  @override
  Widget build(BuildContext context) {
    final lineCount = max(15, _codeController.text.split('\n').length);

    return Container(
      decoration: BoxDecoration(
        color: TechInterviewTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TechInterviewTheme.borderMuted.withValues(alpha: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: TechInterviewTheme.borderMuted),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF85149),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFBBF24),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00D9A3),
                      ),
                    ),
                  ],
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.language,
                    dropdownColor: TechInterviewTheme.cardBg,
                    style: const TextStyle(
                      color: TechInterviewTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<TechInterviewBloc>().add(
                          LanguageChanged(val),
                        );
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'dart', child: Text('Dart')),
                      DropdownMenuItem(
                        value: 'javascript',
                        child: Text('JavaScript'),
                      ),
                      DropdownMenuItem(value: 'python', child: Text('Python')),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Editor Workspace
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Line Numbers
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: TechInterviewTheme.codeEditorBg,
                    border: Border(
                      right: BorderSide(color: TechInterviewTheme.editorLines),
                    ),
                  ),
                  child: Column(
                    children: List.generate(
                      lineCount,
                      (index) => Expanded(
                        child: Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: TechInterviewTheme.textMuted,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Text Area
                Expanded(
                  child: Container(
                    color: TechInterviewTheme.codeEditorBg,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _codeController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.4,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Terminal Console Log Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: TechInterviewTheme.terminalBg,
              border: Border(
                top: BorderSide(color: TechInterviewTheme.borderMuted),
                bottom: BorderSide(color: TechInterviewTheme.borderMuted),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.terminal,
                  color: TechInterviewTheme.terminalText,
                  size: 14,
                ),
                SizedBox(width: 8),
                Text(
                  'CONSOLE OUTPUT',
                  style: TextStyle(
                    color: TechInterviewTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Terminal Console Content
          Container(
            height: 120,
            color: TechInterviewTheme.terminalBg,
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: widget.isSubmitting
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: CircularProgressIndicator(
                          color: TechInterviewTheme.accentGreen,
                        ),
                      ),
                    )
                  : Text(
                      widget.terminalOutput,
                      style: const TextStyle(
                        color: TechInterviewTheme.terminalText,
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
