import '../entities/interview_session.dart';
import '../repositories/session_repository.dart';

class CreateSessionUseCase {
  CreateSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<InterviewSession> call({
    required String targetRole,
    required String seniorityLevel,
    required String targetCompanyId,
  }) {
    return _repository.createSession(
      targetRole: targetRole,
      seniorityLevel: seniorityLevel,
      targetCompanyId: targetCompanyId,
    );
  }
}
