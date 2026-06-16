import '../entities/cv_report.dart';
import '../repositories/cv_report_repository.dart';

class GetCvReportUseCase {
  const GetCvReportUseCase(this._repository);

  final CvReportRepository _repository;

  Future<CvReport> call({
    String? cvFileName,
    int? fileSizeBytes,
    String? stageId,
  }) {
    return _repository.getCvReport(
      cvFileName: cvFileName,
      fileSizeBytes: fileSizeBytes,
      stageId: stageId,
    );
  }
}
