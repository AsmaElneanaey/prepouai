import 'package:equatable/equatable.dart';

abstract class HrInterviewEvent extends Equatable {
  const HrInterviewEvent();

  @override
  List<Object?> get props => [];
}

class HrInterviewRequested extends HrInterviewEvent {
  const HrInterviewRequested();
}

class HrResponseSubmitted extends HrInterviewEvent {
  const HrResponseSubmitted(this.responseText);

  final String responseText;

  @override
  List<Object?> get props => [responseText];
}
