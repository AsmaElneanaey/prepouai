import '../entities/final_report.dart';
import '../entities/report_share_response.dart';

abstract class FinalReportRepository {
  Future<FinalReport> getFinalReport(String id);
  Future<ReportShareResponse> shareReport(String id);
  Future<FinalReport> getSharedReport(String token);
}
