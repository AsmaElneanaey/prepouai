import '../entities/interview_session.dart';
import '../repositories/session_repository.dart';

class GetCurrentStageUseCase {
  GetCurrentStageUseCase(this._repository);

  final SessionRepository _repository;

  Future<SessionStage> call(String sessionId) {
    return _repository.getCurrentStage(sessionId);
  }
}
