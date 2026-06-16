import '../repositories/tech_interview_repository.dart';

class StartTechInterviewStageUseCase {
  const StartTechInterviewStageUseCase(this._repository);

  final TechInterviewRepository _repository;

  Future<void> call(String id) {
    return _repository.startTechInterviewStage(id);
  }
}
