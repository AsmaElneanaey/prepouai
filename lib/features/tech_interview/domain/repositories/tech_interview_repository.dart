import '../entities/tech_interview_session.dart';

abstract class TechInterviewRepository {
  Future<TechInterviewSession> getActiveSession();
  Future<String> submitCode(String code, String language);
  Future<void> startTechInterviewStage(String id);
  Future<void> completeTechInterviewStage(String id);
  Future<String> sendChatMessage({required String id, required String message});
}
