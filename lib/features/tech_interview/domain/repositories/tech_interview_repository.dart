import '../entities/tech_interview_session.dart';

abstract class TechInterviewRepository {
  Future<TechInterviewSession> getActiveSession();
  Future<String> submitCode(String code, String language);
}
