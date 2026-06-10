import 'package:equatable/equatable.dart';

import 'mcq_question.dart';

export 'mcq_option.dart';
export 'mcq_question.dart';

class McqExamSession extends Equatable {
  const McqExamSession({
    required this.questions,
    required this.durationSeconds,
  });

  final List<McqQuestion> questions;
  final int durationSeconds;

  int get totalQuestions => questions.length;

  @override
  List<Object?> get props => [questions, durationSeconds];
}
