import '../entities/hr_next_question.dart';
import '../repositories/hr_interview_repository.dart';

class GetHrNextQuestionUseCase {
  const GetHrNextQuestionUseCase(this._repository);

  final HrInterviewRepository _repository;

  Future<HrNextQuestion> call(String id) {
    return _repository.getNextQuestion(id);
  }
}
