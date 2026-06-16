import '../../domain/entities/hr_interview_session.dart';

class HrInterviewSessionModel {
  HrInterviewSessionModel({
    required this.stageId,
    required this.headerTimerLabel,
    required this.interviewerName,
    required this.interviewerRole,
    required this.liveQuestionCue,
    required this.messages,
  });

  final String stageId;
  final String headerTimerLabel;
  final String interviewerName;
  final String interviewerRole;
  final String liveQuestionCue;
  final List<Map<String, dynamic>> messages;

  HrInterviewSession toEntity() {
    return HrInterviewSession(
      stageId: stageId,
      headerTimerLabel: headerTimerLabel,
      interviewerName: interviewerName,
      interviewerRole: interviewerRole,
      liveQuestionCue: liveQuestionCue,
      messages: messages.map((m) {
        final senderStr = (m['sender'] as String? ?? 'ai').toLowerCase();
        final sender = senderStr == 'user' ? HrMessageSender.user : HrMessageSender.ai;
        return HrInterviewMessage(
          sender: sender,
          body: m['body'] as String? ?? '',
          timestampLabel: m['timestamp'] as String? ?? '',
        );
      }).toList(),
    );
  }
}
