import '../entities/interview_session.dart';
import '../repositories/session_repository.dart';

class UpdateStageStatusUseCase {
  UpdateStageStatusUseCase(this._repository);

  final SessionRepository _repository;

  Future<SessionStage> call({
    required String stageId,
    required String status,
    int? score,
    String? badge,
  }) {
    return _repository.updateStageStatus(
      stageId: stageId,
      status: status,
      score: score,
      badge: badge,
    );
  }
}
