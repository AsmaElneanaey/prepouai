import 'package:equatable/equatable.dart';

import '../../../mcq_complete/domain/entities/mcq_complete_result.dart';
import '../../domain/entities/mcq_exam_session.dart';

abstract class McqExamState extends Equatable {
  const McqExamState();

  @override
  List<Object?> get props => [];
}

class McqExamInitial extends McqExamState {
  const McqExamInitial();
}

class McqExamLoading extends McqExamState {
  const McqExamLoading();
}

class McqExamInProgress extends McqExamState {
  const McqExamInProgress({
    required this.session,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.revealedIndices,
    required this.remainingSeconds,
    this.correctOptionIds = const {},
  });

  final McqExamSession session;
  final int currentIndex;
  final Map<int, String> selectedAnswers;
  final Set<int> revealedIndices;
  final int remainingSeconds;
  final Map<int, String> correctOptionIds;

  McqQuestion get currentQuestion => session.questions[currentIndex];

  int get answeredCount => selectedAnswers.length;

  bool get canGoPrevious => currentIndex > 0;

  bool get isFeedbackVisible => revealedIndices.contains(currentIndex);

  bool get isLastQuestion => currentIndex == session.totalQuestions - 1;

  bool get canGoNext =>
      !isLastQuestion &&
      isFeedbackVisible &&
      currentIndex < session.totalQuestions - 1;

  bool get canFinish => isLastQuestion && isFeedbackVisible;

  String? get selectedOptionId => selectedAnswers[currentIndex];

  bool? get isCurrentAnswerCorrect {
    if (!isFeedbackVisible) return null;
    final selected = selectedAnswers[currentIndex];
    if (selected == null) return null;
    final correctId = correctOptionIds[currentIndex];
    return selected == correctId;
  }

  double get progressFraction =>
      (currentIndex + 1) / session.totalQuestions;

  String get timerLabel {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  McqExamInProgress copyWith({
    int? currentIndex,
    Map<int, String>? selectedAnswers,
    Set<int>? revealedIndices,
    int? remainingSeconds,
    Map<int, String>? correctOptionIds,
  }) {
    return McqExamInProgress(
      session: session,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      revealedIndices: revealedIndices ?? this.revealedIndices,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      correctOptionIds: correctOptionIds ?? this.correctOptionIds,
    );
  }

  @override
  List<Object?> get props => [
        session,
        currentIndex,
        selectedAnswers,
        revealedIndices,
        remainingSeconds,
        correctOptionIds,
      ];
}

class McqExamError extends McqExamState {
  const McqExamError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class McqExamTimeUp extends McqExamState {
  const McqExamTimeUp(this.session, this.selectedAnswers);

  final McqExamSession session;
  final Map<int, String> selectedAnswers;

  @override
  List<Object?> get props => [session, selectedAnswers];
}

class McqExamFinished extends McqExamState {
  const McqExamFinished({
    required this.examState,
    required this.result,
  });

  final McqExamInProgress examState;
  final McqCompleteResult result;

  @override
  List<Object?> get props => [examState, result];
}
