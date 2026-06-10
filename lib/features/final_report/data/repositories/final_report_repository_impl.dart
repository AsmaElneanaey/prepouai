import '../../domain/entities/final_report.dart';
import '../../domain/repositories/final_report_repository.dart';
import '../datasources/final_report_remote_data_source.dart';

class FinalReportRepositoryImpl implements FinalReportRepository {
  FinalReportRepositoryImpl(this._remoteDataSource);

  final FinalReportRemoteDataSource _remoteDataSource;

  @override
  Future<FinalReport> getFinalReport() async {
    final model = await _remoteDataSource.fetchFinalReport();
    return model.toEntity();
  }
}
