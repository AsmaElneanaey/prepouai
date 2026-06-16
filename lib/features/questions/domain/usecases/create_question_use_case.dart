import '../entities/master_question.dart';
import '../repositories/questions_repository.dart';

class CreateQuestionUseCase {
  CreateQuestionUseCase(this._repository);

  final QuestionsRepository _repository;

  Future<MasterQuestion> call({
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
    required String category,
    required String difficulty,
    required List<String> tags,
    required bool isAiGenerated,
    required int estimatedTimeSec,
  }) {
    return _repository.createQuestion(
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
      category: category,
      difficulty: difficulty,
      tags: tags,
      isAiGenerated: isAiGenerated,
      estimatedTimeSec: estimatedTimeSec,
    );
  }
}
