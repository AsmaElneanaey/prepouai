import '../../domain/entities/cv_report.dart';
import '../../domain/repositories/cv_report_repository.dart';
import '../datasources/cv_report_remote_data_source.dart';

class CvReportRepositoryImpl implements CvReportRepository {
  CvReportRepositoryImpl(this._remoteDataSource);

  final CvReportRemoteDataSource _remoteDataSource;

  @override
  Future<CvReport> getCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  }) async {
    final model = await _remoteDataSource.fetchCvReport(
      cvFileName: cvFileName,
      fileSizeBytes: fileSizeBytes,
    );
    return model.toEntity();
  }
}
