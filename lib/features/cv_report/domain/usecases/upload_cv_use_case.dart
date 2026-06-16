import '../entities/cv_upload_response.dart';
import '../repositories/cv_report_repository.dart';

class UploadCvUseCase {
  UploadCvUseCase(this._repository);

  final CvReportRepository _repository;

  Future<CvUploadResponse> call({
    required String stageId,
    required String filePath,
  }) {
    return _repository.uploadCv(
      stageId: stageId,
      filePath: filePath,
    );
  }
}
