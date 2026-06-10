import '../../domain/entities/hr_interview_session.dart';
import '../../domain/repositories/hr_interview_repository.dart';
import '../datasources/hr_interview_remote_data_source.dart';

class HrInterviewRepositoryImpl implements HrInterviewRepository {
  HrInterviewRepositoryImpl(this._remote);

  final HrInterviewRemoteDataSource _remote;

  @override
  Future<HrInterviewSession> getActiveSession() async {
    final model = await _remote.fetchActiveSession();
    return model.toEntity();
  }
}
