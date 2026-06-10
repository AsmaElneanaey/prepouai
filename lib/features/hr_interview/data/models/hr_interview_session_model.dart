import '../../domain/entities/hr_interview_session.dart';

class HrInterviewSessionModel {
  HrInterviewSessionModel({
    required this.headerTimerLabel,
    required this.interviewerName,
    required this.interviewerRole,
    required this.liveQuestionCue,
    required this.messages,
  });

  final String headerTimerLabel;
  final String interviewerName;
  final String interviewerRole;
  final String liveQuestionCue;
  final List<Map<String, dynamic>> messages;

  HrInterviewSession toEntity() {
    return HrInterviewSession(
      headerTimerLabel: headerTimerLabel,
      interviewerName: interviewerName,
      interviewerRole: interviewerRole,
      liveQuestionCue: liveQuestionCue,
      messages: messages.map((m) {
        return HrInterviewMessage(
          sender: HrMessageSender.values.byName(m['sender'] as String),
          body: m['body'] as String,
          timestampLabel: m['timestamp'] as String,
        );
      }).toList(),
    );
  }
}
