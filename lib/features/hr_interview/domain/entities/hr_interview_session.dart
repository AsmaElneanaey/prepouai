import 'package:equatable/equatable.dart';

import 'hr_message.dart';

export 'hr_message.dart';

class HrInterviewSession extends Equatable {
  const HrInterviewSession({
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
  /// Shown in the cue bar (e.g. quoted question).
  final String liveQuestionCue;
  final List<HrInterviewMessage> messages;

  HrInterviewSession copyWith({
    String? stageId,
    String? headerTimerLabel,
    String? interviewerName,
    String? interviewerRole,
    String? liveQuestionCue,
    List<HrInterviewMessage>? messages,
  }) {
    return HrInterviewSession(
      stageId: stageId ?? this.stageId,
      headerTimerLabel: headerTimerLabel ?? this.headerTimerLabel,
      interviewerName: interviewerName ?? this.interviewerName,
      interviewerRole: interviewerRole ?? this.interviewerRole,
      liveQuestionCue: liveQuestionCue ?? this.liveQuestionCue,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        stageId,
        headerTimerLabel,
        interviewerName,
        interviewerRole,
        liveQuestionCue,
        messages,
      ];
}
