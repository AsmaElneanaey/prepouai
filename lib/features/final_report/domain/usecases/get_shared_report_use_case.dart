import '../entities/final_report.dart';
import '../repositories/final_report_repository.dart';

class GetSharedReportUseCase {
  const GetSharedReportUseCase(this._repository);

  final FinalReportRepository _repository;

  Future<FinalReport> call(String token) {
    return _repository.getSharedReport(token);
  }
}
