import '../../../mcq_exam/domain/entities/mcq_exam_session.dart';
import '../entities/mcq_complete_result.dart';

abstract class McqCompleteRepository {
  McqCompleteResult calculateResult({
    required McqExamSession session,
    required Map<int, String> selectedAnswers,
  });
}
