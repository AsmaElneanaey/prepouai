import '../entities/cv_parse_response.dart';
import '../repositories/cv_report_repository.dart';

class ParseCvUseCase {
  ParseCvUseCase(this._repository);

  final CvReportRepository _repository;

  Future<CvParseResponse> call(String id) {
    return _repository.parseCv(id);
  }
}
