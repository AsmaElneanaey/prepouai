import '../../../mcq_exam/domain/entities/mcq_exam_session.dart';
import '../entities/mcq_complete_result.dart';
import '../repositories/mcq_complete_repository.dart';

class CalculateMcqResultUseCase {
  const CalculateMcqResultUseCase(this._repository);

  final McqCompleteRepository _repository;

  McqCompleteResult call({
    required McqExamSession session,
    required Map<int, String> selectedAnswers,
  }) {
    return _repository.calculateResult(
      session: session,
      selectedAnswers: selectedAnswers,
    );
  }
}
