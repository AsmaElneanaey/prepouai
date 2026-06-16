import '../entities/mcq_exam_session.dart';
import '../repositories/mcq_exam_repository.dart';

class StartMcqStageUseCase {
  StartMcqStageUseCase(this._repository);

  final McqExamRepository _repository;

  Future<McqExamSession> call(String id) {
    return _repository.startMcqStage(id);
  }
}
