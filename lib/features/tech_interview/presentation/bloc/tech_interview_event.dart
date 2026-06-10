import 'package:equatable/equatable.dart';

abstract class TechInterviewEvent extends Equatable {
  const TechInterviewEvent();

  @override
  List<Object?> get props => [];
}

class TechInterviewRequested extends TechInterviewEvent {
  const TechInterviewRequested();
}

class CodeChanged extends TechInterviewEvent {
  const CodeChanged(this.code);
  final String code;

  @override
  List<Object?> get props => [code];
}

class LanguageChanged extends TechInterviewEvent {
  const LanguageChanged(this.language);
  final String language;

  @override
  List<Object?> get props => [language];
}

class SubmitCodePressed extends TechInterviewEvent {
  const SubmitCodePressed();
}

class SendMessagePressed extends TechInterviewEvent {
  const SendMessagePressed(this.body);
  final String body;

  @override
  List<Object?> get props => [body];
}
