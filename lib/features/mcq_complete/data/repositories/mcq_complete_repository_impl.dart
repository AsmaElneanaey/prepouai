import '../../../mcq_exam/domain/entities/mcq_exam_session.dart';
import '../../domain/entities/mcq_complete_result.dart';
import '../../domain/repositories/mcq_complete_repository.dart';

class McqCompleteRepositoryImpl implements McqCompleteRepository {
  static const int passThresholdPercent = 70;

  @override
  McqCompleteResult calculateResult({
    required McqExamSession session,
    required Map<int, String> selectedAnswers,
  }) {
    var correctCount = 0;
    final topicStats = <String, ({int correct, int total})>{};

    for (var i = 0; i < session.questions.length; i++) {
      final question = session.questions[i];
      final answer = selectedAnswers[i];
      if (answer == null) continue;

      final isCorrect = answer == question.correctOptionId;
      if (isCorrect) correctCount++;

      final existing = topicStats[question.category];
      topicStats[question.category] = (
        correct: (existing?.correct ?? 0) + (isCorrect ? 1 : 0),
        total: (existing?.total ?? 0) + 1,
      );
    }

    final totalCount = selectedAnswers.length;
    final scorePercent = totalCount == 0
        ? 0
        : ((correctCount / totalCount) * 100).round();

    final topics = topicStats.entries
        .map(
          (e) => TopicBreakdown(
            name: e.key,
            correct: e.value.correct,
            total: e.value.total,
          ),
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return McqCompleteResult(
      scorePercent: scorePercent,
      isPass: scorePercent >= passThresholdPercent,
      correctCount: correctCount,
      totalCount: totalCount,
      topics: topics,
    );
  }
}
