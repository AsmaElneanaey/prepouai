import 'package:equatable/equatable.dart';
import 'hr_message.dart';

class HrSubmitResponse extends Equatable {
  const HrSubmitResponse({
    required this.userMessage,
    required this.aiReplyMessage,
    required this.completed,
    this.nextQuestion,
  });

  final HrInterviewMessage userMessage;
  final HrInterviewMessage aiReplyMessage;
  final bool completed;
  final String? nextQuestion;

  @override
  List<Object?> get props => [userMessage, aiReplyMessage, completed, nextQuestion];
}

