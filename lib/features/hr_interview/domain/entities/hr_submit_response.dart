import 'package:equatable/equatable.dart';
import 'hr_message.dart';

class HrSubmitResponse extends Equatable {
  const HrSubmitResponse({
    required this.userMessage,
    required this.aiReplyMessage,
  });

  final HrInterviewMessage userMessage;
  final HrInterviewMessage aiReplyMessage;

  @override
  List<Object?> get props => [userMessage, aiReplyMessage];
}
