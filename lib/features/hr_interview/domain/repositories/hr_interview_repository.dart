import '../entities/hr_interview_session.dart';

abstract class HrInterviewRepository {
  Future<HrInterviewSession> getActiveSession();
}
