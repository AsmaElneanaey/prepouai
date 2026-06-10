import 'package:equatable/equatable.dart';

enum TechMessageSender { ai, user }

class TechChatMessage extends Equatable {
  const TechChatMessage({
    required this.sender,
    required this.body,
    required this.timestampLabel,
  });

  final TechMessageSender sender;
  final String body;
  final String timestampLabel;

  @override
  List<Object?> get props => [sender, body, timestampLabel];
}
