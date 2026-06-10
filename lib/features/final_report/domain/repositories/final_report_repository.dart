import '../entities/final_report.dart';

abstract class FinalReportRepository {
  Future<FinalReport> getFinalReport();
}
