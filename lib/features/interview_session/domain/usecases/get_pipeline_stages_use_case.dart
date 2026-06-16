import '../entities/interview_session.dart';
import '../repositories/session_repository.dart';

class GetPipelineStagesUseCase {
  GetPipelineStagesUseCase(this._repository);

  final SessionRepository _repository;

  Future<List<SessionStage>> call(String sessionId) {
    return _repository.getPipelineStages(sessionId);
  }
}
