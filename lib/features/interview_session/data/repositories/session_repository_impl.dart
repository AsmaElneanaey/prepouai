import '../../domain/entities/interview_session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._remoteDataSource);

  final SessionRemoteDataSource _remoteDataSource;

  @override
  Future<InterviewSession> createSession({
    required String targetRole,
    required String seniorityLevel,
    required String targetCompanyId,
  }) async {
    final response = await _remoteDataSource.createSession(
      targetRole: targetRole,
      seniorityLevel: seniorityLevel,
      targetCompanyId: targetCompanyId,
    );
    return response.session.toEntity();
  }

  @override
  Future<List<InterviewSession>> getUserSessions() async {
    final response = await _remoteDataSource.getUserSessions();
    return response.sessions.map((e) => e.toEntity()).toList();
  }

  @override
  Future<InterviewSession> getSessionDetails(String sessionId) async {
    final response = await _remoteDataSource.getSessionDetails(sessionId);
    return response.session.toEntity();
  }

  @override
  Future<SessionStage> getCurrentStage(String sessionId) async {
    final response = await _remoteDataSource.getCurrentStage(sessionId);
    return response.stage.toEntity();
  }

  @override
  Future<List<SessionStage>> getPipelineStages(String sessionId) async {
    final response = await _remoteDataSource.getPipelineStages(sessionId);
    return response.stages.map((e) => e.toEntity()).toList();
  }

  @override
  Future<SessionStage> updateStageStatus({
    required String stageId,
    required String status,
    int? score,
    String? badge,
  }) async {
    final response = await _remoteDataSource.updateStageStatus(
      stageId: stageId,
      status: status,
      score: score,
      badge: badge,
    );
    return response.stage.toEntity();
  }
}
