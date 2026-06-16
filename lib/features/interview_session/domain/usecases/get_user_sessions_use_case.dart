import '../entities/interview_session.dart';
import '../repositories/session_repository.dart';

class GetUserSessionsUseCase {
  GetUserSessionsUseCase(this._repository);

  final SessionRepository _repository;

  Future<List<InterviewSession>> call() {
    return _repository.getUserSessions();
  }
}
