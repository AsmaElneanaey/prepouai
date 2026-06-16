import 'package:equatable/equatable.dart';

import 'code_question.dart';
import 'tech_chat_message.dart';

export 'code_question.dart';
export 'tech_chat_message.dart';

class TechInterviewSession extends Equatable {
  const TechInterviewSession({
    required this.stageId,
    required this.headerTimerLabel,
    required this.interviewerName,
    required this.interviewerRole,
    required this.question,
    required this.messages,
  });

  final String stageId;
  final String headerTimerLabel;
  final String interviewerName;
  final String interviewerRole;
  final CodeQuestion question;
  final List<TechChatMessage> messages;

  TechInterviewSession copyWith({
    String? stageId,
    String? headerTimerLabel,
    String? interviewerName,
    String? interviewerRole,
    CodeQuestion? question,
    List<TechChatMessage>? messages,
  }) {
    return TechInterviewSession(
      stageId: stageId ?? this.stageId,
      headerTimerLabel: headerTimerLabel ?? this.headerTimerLabel,
      interviewerName: interviewerName ?? this.interviewerName,
      interviewerRole: interviewerRole ?? this.interviewerRole,
      question: question ?? this.question,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        stageId,
        headerTimerLabel,
        interviewerName,
        interviewerRole,
        question,
        messages,
      ];
}
