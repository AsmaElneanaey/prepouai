import '../../domain/entities/tech_interview_session.dart';

class TechInterviewSessionModel {
  TechInterviewSessionModel({
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
      headerTimerLabel: headerTimerLabel,
      interviewerName: interviewerName,
      interviewerRole: interviewerRole,
      question: CodeQuestion(
        title: questionTitle,
        description: questionDescription,
        difficulty: TechDifficulty.values.byName(questionDifficulty),
        starterCode: questionStarterCode,
        language: questionLanguage,
      ),
      messages: messages.map((m) {
        return TechChatMessage(
          sender: TechMessageSender.values.byName(m['sender'] as String),
          body: m['body'] as String,
          timestampLabel: m['timestamp'] as String,
        );
      }).toList(),
    );
  }
}
