import '../entities/interview_session.dart';
import '../repositories/session_repository.dart';

class GetSessionDetailsUseCase {
  GetSessionDetailsUseCase(this._repository);

  final SessionRepository _repository;

  Future<InterviewSession> call(String sessionId) {
    return _repository.getSessionDetails(sessionId);
  }
}
