import '../entities/final_report.dart';
import '../repositories/final_report_repository.dart';

class GetFinalReportUseCase {
  const GetFinalReportUseCase(this._repository);

  final FinalReportRepository _repository;

  Future<FinalReport> call() => _repository.getFinalReport();
}
