import '../entities/mcq_answer_response.dart';
import '../repositories/mcq_exam_repository.dart';

class SubmitMcqAnswerUseCase {
  SubmitMcqAnswerUseCase(this._repository);

  final McqExamRepository _repository;

  Future<McqAnswerResponse> call({
    required String id,
    required String questionId,
    required int selectedOptionIndex,
    required int timeSpentSeconds,
  }) {
    return _repository.submitAnswer(
      id: id,
      questionId: questionId,
      selectedOptionIndex: selectedOptionIndex,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}
