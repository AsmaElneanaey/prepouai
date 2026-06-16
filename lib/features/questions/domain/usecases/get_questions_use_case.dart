import '../entities/master_question.dart';
import '../repositories/questions_repository.dart';

class GetQuestionsUseCase {
  GetQuestionsUseCase(this._repository);

  final QuestionsRepository _repository;

  Future<List<MasterQuestion>> call() {
    return _repository.getQuestions();
  }
}
