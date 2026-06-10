import '../models/hr_interview_session_model.dart';

abstract class HrInterviewRemoteDataSource {
  Future<HrInterviewSessionModel> fetchActiveSession();
}

class HrInterviewRemoteDataSourceImpl implements HrInterviewRemoteDataSource {
  @override
  Future<HrInterviewSessionModel> fetchActiveSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return HrInterviewSessionModel(
      headerTimerLabel: '0:02',
      interviewerName: 'PrepYou AI',
      interviewerRole: 'HR Interviewer',
      liveQuestionCue: '"Tell me about yourself."',
      messages: const [
        {
          'sender': 'ai',
          'body':
              "Hello! I'm your PrepYou AI HR Interviewer. Let's start with a classic — tell me about yourself and your background.",
          'timestamp': '0:00',
        },
        {
          'sender': 'user',
          'body':
              "Hi! I'm a Senior Frontend Engineer with 5 years of experience building scalable web applications...",
          'timestamp': '0:32',
        },
        {
          'sender': 'ai',
          'body':
              'Great background! Can you walk me through a challenging project you led and what the outcome was?',
          'timestamp': '1:05',
        },
      ],
    );
  }
}
