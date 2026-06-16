import '../entities/hr_interview_session.dart';
import '../entities/hr_submit_response.dart';
import '../entities/hr_next_question.dart';

abstract class HrInterviewRepository {
  Future<HrInterviewSession> getActiveSession();

  Future<void> startHrInterviewStage({
    required String id,
    required String focusArea,
  });

  Future<HrSubmitResponse> submitResponse({
    required String id,
    required String responseText,
    String? audioRecordingUrl,
  });

  Future<HrNextQuestion> getNextQuestion(String id);
}
