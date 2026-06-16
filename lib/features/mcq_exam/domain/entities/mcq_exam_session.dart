import 'package:equatable/equatable.dart';

import 'mcq_question.dart';

export 'mcq_option.dart';
export 'mcq_question.dart';

class McqExamSession extends Equatable {
  const McqExamSession({
    required this.stageId,
    required this.questions,
    required this.durationSeconds,
  });

  final String stageId;
  final List<McqQuestion> questions;
  final int durationSeconds;

  int get totalQuestions => questions.length;

  @override
  List<Object?> get props => [stageId, questions, durationSeconds];
}

