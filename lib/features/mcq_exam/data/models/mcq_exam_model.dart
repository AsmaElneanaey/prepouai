import '../../domain/entities/mcq_exam_session.dart';

class McqExamModel {
  McqExamModel({
    required this.questions,
    required this.durationSeconds,
  });

  final List<Map<String, dynamic>> questions;
  final int durationSeconds;

  McqExamSession toEntity() {
    return McqExamSession(
      durationSeconds: durationSeconds,
      questions: questions.asMap().entries.map((entry) {
        final q = entry.value;
        final options = (q['options'] as List)
            .map(
              (o) => McqOption(
                id: o['id'] as String,
                label: o['label'] as String,
              ),
            )
            .toList();
        return McqQuestion(
          index: entry.key + 1,
          category: q['category'] as String,
          difficulty: McqDifficulty.values.byName(q['difficulty'] as String),
          text: q['text'] as String,
          options: options,
          correctOptionId: q['correctOptionId'] as String,
          explanation: q['explanation'] as String,
        );
      }).toList(),
    );
  }
}
