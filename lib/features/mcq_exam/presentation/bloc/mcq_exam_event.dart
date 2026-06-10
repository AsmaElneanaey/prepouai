import 'package:equatable/equatable.dart';

abstract class McqExamEvent extends Equatable {
  const McqExamEvent();

  @override
  List<Object?> get props => [];
}

class McqExamRequested extends McqExamEvent {
  const McqExamRequested();
}

class McqAnswerSelected extends McqExamEvent {
  const McqAnswerSelected(this.optionId);

  final String optionId;

  @override
  List<Object?> get props => [optionId];
}

class McqNextPressed extends McqExamEvent {
  const McqNextPressed();
}

class McqPreviousPressed extends McqExamEvent {
  const McqPreviousPressed();
}

class McqTimerTicked extends McqExamEvent {
  const McqTimerTicked();
}

class McqFinishPressed extends McqExamEvent {
  const McqFinishPressed();
}
