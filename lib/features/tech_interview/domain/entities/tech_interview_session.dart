import 'package:equatable/equatable.dart';

import 'code_question.dart';
import 'tech_chat_message.dart';

export 'code_question.dart';
export 'tech_chat_message.dart';

class TechInterviewSession extends Equatable {
  const TechInterviewSession({
    required this.headerTimerLabel,
    required this.interviewerName,
    required this.interviewerRole,
    required this.question,
    required this.messages,
  });

  final String headerTimerLabel;
  final String interviewerName;
  final String interviewerRole;
  final CodeQuestion question;
  final List<TechChatMessage> messages;

  @override
  List<Object?> get props => [
        headerTimerLabel,
        interviewerName,
        interviewerRole,
        question,
        messages,
      ];
}
