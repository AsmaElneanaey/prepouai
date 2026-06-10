import 'package:flutter/material.dart';

import '../../domain/entities/ai_suggestion.dart';
import '../theme/cv_report_theme.dart';

class AiSuggestionsCard extends StatelessWidget {
  const AiSuggestionsCard({super.key, required this.suggestions});

  final List<AiSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 17),
      decoration: CvReportTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI SUGGESTIONS', style: CvReportTheme.sectionLabel),
          const SizedBox(height: 12),
          ...suggestions.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SuggestionTile(message: s.message),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0x0FFBBF24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x26FBBF24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: CvReportTheme.starColor,
            size: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: CvReportTheme.suggestionText,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
