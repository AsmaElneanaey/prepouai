import '../entities/mcq_complete_response.dart';
import '../repositories/mcq_exam_repository.dart';

class CompleteMcqStageUseCase {
  CompleteMcqStageUseCase(this._repository);

  final McqExamRepository _repository;

  Future<McqCompleteResponse> call(String id) {
    return _repository.completeMcqStage(id);
  }
}
