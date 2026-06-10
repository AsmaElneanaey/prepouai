import '../../domain/entities/mcq_exam_session.dart';
import '../../domain/repositories/mcq_exam_repository.dart';
import '../datasources/mcq_exam_remote_data_source.dart';

class McqExamRepositoryImpl implements McqExamRepository {
  McqExamRepositoryImpl(this._remoteDataSource);

  final McqExamRemoteDataSource _remoteDataSource;

  @override
  Future<McqExamSession> getExamSession() async {
    final model = await _remoteDataSource.fetchExamSession();
    return model.toEntity();
  }
}
