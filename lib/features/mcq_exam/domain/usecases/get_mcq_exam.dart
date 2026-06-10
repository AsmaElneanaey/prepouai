import '../entities/mcq_exam_session.dart';
import '../repositories/mcq_exam_repository.dart';

class GetMcqExamUseCase {
  const GetMcqExamUseCase(this._repository);

  final McqExamRepository _repository;

  Future<McqExamSession> call() => _repository.getExamSession();
}
