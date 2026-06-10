import 'package:equatable/equatable.dart';

class AiSuggestion extends Equatable {
  const AiSuggestion({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
