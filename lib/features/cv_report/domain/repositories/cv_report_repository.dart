import '../entities/cv_report.dart';
import '../entities/cv_upload_response.dart';
import '../entities/cv_parse_response.dart';
import '../../../skills/domain/entities/skill.dart';

abstract class CvReportRepository {
  Future<CvReport> getCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  });

  Future<CvUploadResponse> uploadCv(String filePath);

  Future<CvParseResponse> parseCv(String id);

  Future<List<Skill>> getCvSkills(String id);
}
