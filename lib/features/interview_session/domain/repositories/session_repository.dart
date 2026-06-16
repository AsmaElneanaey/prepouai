import '../entities/interview_session.dart';

abstract class SessionRepository {
  Future<InterviewSession> createSession({
    required String targetRole,
    required String seniorityLevel,
    required String targetCompanyId,
  });

  Future<List<InterviewSession>> getUserSessions();

  Future<InterviewSession> getSessionDetails(String sessionId);

  Future<SessionStage> getCurrentStage(String sessionId);

  Future<List<SessionStage>> getPipelineStages(String sessionId);

  Future<SessionStage> updateStageStatus({
    required String stageId,
    required String status,
    int? score,
    String? badge,
  });
}
