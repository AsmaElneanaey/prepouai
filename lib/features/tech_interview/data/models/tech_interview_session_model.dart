import '../../domain/entities/tech_interview_session.dart';

class TechInterviewSessionModel {
  TechInterviewSessionModel({
    required this.stageId,
    required this.headerTimerLabel,
    required this.interviewerName,
    required this.interviewerRole,
    required this.questionTitle,
    required this.questionDescription,
    required this.questionDifficulty,
    required this.questionStarterCode,
    required this.questionLanguage,
    required this.messages,
  });

  final String stageId;
  final String headerTimerLabel;
  final String interviewerName;
  final String interviewerRole;
  final String questionTitle;
  final String questionDescription;
  final String questionDifficulty;
  final String questionStarterCode;
  final String questionLanguage;
  final List<Map<String, dynamic>> messages;

  TechInterviewSession toEntity() {
    return TechInterviewSession(
      stageId: stageId,
      headerTimerLabel: headerTimerLabel,
      interviewerName: interviewerName,
      interviewerRole: interviewerRole,
      question: CodeQuestion(
        title: questionTitle,
        description: questionDescription,
        difficulty: _parseDifficulty(questionDifficulty),
        starterCode: questionStarterCode,
        language: questionLanguage,
      ),
      messages: messages.map((m) {
        final senderStr = (m['sender'] as String? ?? 'ai').toLowerCase();
        final sender = senderStr == 'user' ? TechMessageSender.user : TechMessageSender.ai;
        return TechChatMessage(
          sender: sender,
          body: m['body'] as String? ?? '',
          timestampLabel: m['timestamp'] as String? ?? '',
        );
      }).toList(),
    );
  }

  TechDifficulty _parseDifficulty(String diff) {
    switch (diff.toLowerCase()) {
      case 'medium':
        return TechDifficulty.medium;
      case 'hard':
        return TechDifficulty.hard;
      case 'easy':
      default:
        return TechDifficulty.easy;
    }
  }
}
