import '../repositories/tech_interview_repository.dart';

class CompleteTechInterviewStageUseCase {
  const CompleteTechInterviewStageUseCase(this._repository);

  final TechInterviewRepository _repository;

  Future<void> call(String id) {
    return _repository.completeTechInterviewStage(id);
  }
}
