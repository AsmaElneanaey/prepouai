import 'package:equatable/equatable.dart';

import 'hr_message.dart';

export 'hr_message.dart';

class HrInterviewSession extends Equatable {
  const HrInterviewSession({
    required this.headerTimerLabel,
    required this.interviewerName,
    required this.interviewerRole,
    required this.liveQuestionCue,
    required this.messages,
  });

  final String headerTimerLabel;
  final String interviewerName;
  final String interviewerRole;
  /// Shown in the cue bar (e.g. quoted question).
  final String liveQuestionCue;
  final List<HrInterviewMessage> messages;

  @override
  List<Object?> get props => [
        headerTimerLabel,
        interviewerName,
        interviewerRole,
        liveQuestionCue,
        messages,
      ];
}
