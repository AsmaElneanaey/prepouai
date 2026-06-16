import '../../domain/entities/mcq_exam_session.dart';

class McqExamModel {
  McqExamModel({
    required this.questions,
    required this.durationSeconds,
    this.stageId,
  });

  final List<Map<String, dynamic>> questions;
  final int durationSeconds;
  final String? stageId;

  McqExamSession toEntity([String? fallbackStageId]) {
    return McqExamSession(
      stageId: stageId ?? fallbackStageId ?? '',
      durationSeconds: durationSeconds,
      questions: questions.asMap().entries.map((entry) {
        final q = entry.value;
        final rawOptions = q['options'] as List<dynamic>? ?? const [];
        final options = rawOptions.asMap().entries.map((optEntry) {
          final optIdx = optEntry.key;
          final optVal = optEntry.value;
          if (optVal is Map) {
            return McqOption(
              id: optVal['id']?.toString() ?? optIdx.toString(),
              label: optVal['label']?.toString() ?? '',
            );
          }
          return McqOption(
            id: optIdx.toString(),
            label: optVal.toString(),
          );
        }).toList();

        final categoryList = (q['skill_tags'] as List?) ?? (q['tags'] as List?) ?? [];
        final category = q['category'] as String? ?? (categoryList.isNotEmpty ? categoryList.first.toString() : 'General');

        return McqQuestion(
          id: q['_id'] as String? ?? q['id'] as String? ?? '',
          index: entry.key + 1,
          category: category,
          difficulty: _parseDifficulty(q['difficulty']),
          text: q['question_text'] as String? ?? q['text'] as String? ?? '',
          options: options,
          correctOptionId: q['correctOptionId'] as String? ?? '',
          explanation: q['explanation'] as String? ?? '',
        );
      }).toList(),
    );
  }

  McqDifficulty _parseDifficulty(dynamic diff) {
    if (diff == null) return McqDifficulty.medium;
    final diffStr = diff.toString().toLowerCase();
    for (final val in McqDifficulty.values) {
      if (val.name == diffStr) return val;
    }
    return McqDifficulty.medium;
  }
}

