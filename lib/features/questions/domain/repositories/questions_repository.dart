import '../entities/master_question.dart';

abstract class QuestionsRepository {
  Future<MasterQuestion> createQuestion({
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
    required String category,
    required String difficulty,
    required List<String> tags,
    required bool isAiGenerated,
    required int estimatedTimeSec,
  });

  Future<List<MasterQuestion>> getQuestions();
}
