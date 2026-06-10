import 'package:equatable/equatable.dart';

enum HrMessageSender { ai, user }

class HrInterviewMessage extends Equatable {
  const HrInterviewMessage({
    required this.sender,
    required this.body,
    required this.timestampLabel,
  });

  final HrMessageSender sender;
  final String body;
  final String timestampLabel;

  @override
  List<Object?> get props => [sender, body, timestampLabel];
}
