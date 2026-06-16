import '../entities/report_share_response.dart';
import '../repositories/final_report_repository.dart';

class ShareReportUseCase {
  const ShareReportUseCase(this._repository);

  final FinalReportRepository _repository;

  Future<ReportShareResponse> call(String id) {
    return _repository.shareReport(id);
  }
}
