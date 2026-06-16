import '../entities/mcq_exam_session.dart';
import '../entities/mcq_answer_response.dart';
import '../entities/mcq_complete_response.dart';

abstract class McqExamRepository {
  Future<McqExamSession> getExamSession();

  Future<McqExamSession> startMcqStage(String id);

  Future<McqAnswerResponse> submitAnswer({
    required String id,
    required String questionId,
    required int selectedOptionIndex,
    required int timeSpentSeconds,
  });

  Future<McqCompleteResponse> completeMcqStage(String id);
}
