import '../entities/cv_report.dart';

abstract class CvReportRepository {
  Future<CvReport> getCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  });
}
