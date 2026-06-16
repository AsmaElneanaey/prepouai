import '../../domain/entities/cv_report.dart';
import '../../domain/entities/cv_upload_response.dart';
import '../../domain/entities/cv_parse_response.dart';
import '../../../skills/domain/entities/skill.dart';
import '../../domain/repositories/cv_report_repository.dart';
import '../datasources/cv_report_remote_data_source.dart';

class CvReportRepositoryImpl implements CvReportRepository {
  CvReportRepositoryImpl(this._remoteDataSource);

  final CvReportRemoteDataSource _remoteDataSource;

  @override
  Future<CvReport> getCvReport({
    String? cvFileName,
    int? fileSizeBytes,
    String? stageId,
  }) async {
    final model = await _remoteDataSource.fetchCvReport(
      cvFileName: cvFileName,
      fileSizeBytes: fileSizeBytes,
      stageId: stageId,
    );
    return model.toEntity();
  }

  @override
  Future<CvUploadResponse> uploadCv({
    required String stageId,
    required String filePath,
  }) async {
    final dto = await _remoteDataSource.uploadCv(
      stageId: stageId,
      filePath: filePath,
    );
    return dto.data.toEntity();
  }

  @override
  Future<CvParseResponse> parseCv(String id) async {
    final dto = await _remoteDataSource.parseCv(id);
    return dto.data.toEntity();
  }

  @override
  Future<List<Skill>> getCvSkills(String id) async {
    final dto = await _remoteDataSource.getCvSkills(id);
    return dto.skills.map((s) => s.toEntity()).toList();
  }
}
