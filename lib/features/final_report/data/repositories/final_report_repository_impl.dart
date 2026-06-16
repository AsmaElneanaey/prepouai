import '../../domain/entities/final_report.dart';
import '../../domain/entities/report_share_response.dart';
import '../../domain/repositories/final_report_repository.dart';
import '../datasources/final_report_remote_data_source.dart';

class FinalReportRepositoryImpl implements FinalReportRepository {
  FinalReportRepositoryImpl(this._remoteDataSource);

  final FinalReportRemoteDataSource _remoteDataSource;

  @override
  Future<FinalReport> getFinalReport(String id) async {
    if (id == 'active' || id.isEmpty) {
      final model = await _remoteDataSource.fetchFinalReport();
      return model.toEntity();
    }
    final dto = await _remoteDataSource.fetchFinalReportById(id);
    return dto.data.toEntity();
  }

  @override
  Future<ReportShareResponse> shareReport(String id) async {
    final dto = await _remoteDataSource.shareReport(id);
    return dto.data.toEntity();
  }

  @override
  Future<FinalReport> getSharedReport(String token) async {
    final dto = await _remoteDataSource.fetchSharedReport(token);
    return dto.data.toEntity();
  }
}
