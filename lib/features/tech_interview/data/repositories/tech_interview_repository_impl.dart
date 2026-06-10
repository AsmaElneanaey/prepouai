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
  Future<String> submitCode(String code, String language) async {
    return _remoteDataSource.submitCode(code, language);
  }
}
