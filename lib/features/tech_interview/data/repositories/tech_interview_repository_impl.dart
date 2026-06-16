import '../../domain/entities/tech_interview_session.dart';
import '../../domain/repositories/tech_interview_repository.dart';
import '../datasources/tech_interview_remote_data_source.dart';

class TechInterviewRepositoryImpl implements TechInterviewRepository {
  TechInterviewRepositoryImpl(this._remoteDataSource);

  final TechInterviewRemoteDataSource _remoteDataSource;

  @override
  Future<TechInterviewSession> getActiveSession() async {
    final model = await _remoteDataSource.fetchActiveSession();
    return model.toEntity();
  }

  @override
  Future<String> submitCode({
    required String techInterviewId,
    required String problemId,
    required String code,
    required String language,
  }) async {
    return _remoteDataSource.submitCode(
      techInterviewId: techInterviewId,
      problemId: problemId,
      code: code,
      language: language,
    );
  }

  @override
  Future<void> startTechInterviewStage(String id) async {
    await _remoteDataSource.startTechStage(id);
  }

  @override
  Future<void> completeTechInterviewStage(String id) async {
    await _remoteDataSource.completeTechStage(id);
  }

  @override
  Future<String> sendChatMessage({required String id, required String message}) async {
    return _remoteDataSource.sendChatMessage(id: id, message: message);
  }
}
