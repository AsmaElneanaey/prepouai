import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_mcq_exam.dart';
import '../../domain/usecases/submit_mcq_answer_use_case.dart';
import '../../domain/usecases/complete_mcq_stage_use_case.dart';
import '../../../mcq_complete/domain/entities/mcq_complete_result.dart';
import 'mcq_exam_event.dart';
import 'mcq_exam_state.dart';

class McqExamBloc extends Bloc<McqExamEvent, McqExamState> {
  McqExamBloc(
    this._getMcqExam,
    this._submitAnswer,
    this._completeMcqStage,
  ) : super(const McqExamInitial()) {
    on<McqExamRequested>(_onRequested);
    on<McqAnswerSelected>(_onAnswerSelected);
    on<McqNextPressed>(_onNext);
    on<McqPreviousPressed>(_onPrevious);
    on<McqTimerTicked>(_onTimerTicked);
    on<McqFinishPressed>(_onFinish);
  }

  final GetMcqExamUseCase _getMcqExam;
  final SubmitMcqAnswerUseCase _submitAnswer;
  final CompleteMcqStageUseCase _completeMcqStage;
  Timer? _timer;

  Future<void> _onRequested(
    McqExamRequested event,
    Emitter<McqExamState> emit,
  ) async {
    emit(const McqExamLoading());
    try {
      final session = await _getMcqExam();
      emit(
        McqExamInProgress(
          session: session,
          currentIndex: 0,
          selectedAnswers: const {},
          revealedIndices: const {},
          remainingSeconds: session.durationSeconds,
          correctOptionIds: const {},
        ),
      );
      _startTimer();
    } catch (e) {
      emit(McqExamError(e.toString()));
    }
  }

  Future<void> _onAnswerSelected(
    McqAnswerSelected event,
    Emitter<McqExamState> emit,
  ) async {
    final current = state;
    if (current is! McqExamInProgress) return;
    if (current.isFeedbackVisible) return;

    try {
      final question = current.currentQuestion;
      
      int selectedOptionIndex = question.options.indexWhere((opt) => opt.id == event.optionId);
      if (selectedOptionIndex == -1) {
        try {
          selectedOptionIndex = int.parse(event.optionId);
        } catch (_) {
          selectedOptionIndex = 0;
        }
      }

      // Call real submit API
      final answerResponse = await _submitAnswer(
        id: current.session.stageId,
        questionId: question.id,
        selectedOptionIndex: selectedOptionIndex,
        timeSpentSeconds: 15, // standard default fallback
      );

      final correctIndex = answerResponse.correctOptionIndex ?? 0;
      final correctOptionId = correctIndex.toString();

      final updatedAnswers = Map<int, String>.from(current.selectedAnswers)
        ..[current.currentIndex] = event.optionId;
      final updatedRevealed = Set<int>.from(current.revealedIndices)
        ..add(current.currentIndex);
      final updatedCorrectOptionIds = Map<int, String>.from(current.correctOptionIds)
        ..[current.currentIndex] = correctOptionId;

      emit(
        current.copyWith(
          selectedAnswers: updatedAnswers,
          revealedIndices: updatedRevealed,
          correctOptionIds: updatedCorrectOptionIds,
        ),
      );
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('Question already answered') || errorStr.contains('already answered')) {
        final updatedAnswers = Map<int, String>.from(current.selectedAnswers)
          ..[current.currentIndex] = event.optionId;
        final updatedRevealed = Set<int>.from(current.revealedIndices)
          ..add(current.currentIndex);
        final updatedCorrectOptionIds = Map<int, String>.from(current.correctOptionIds)
          ..[current.currentIndex] = event.optionId;

        emit(
          current.copyWith(
            selectedAnswers: updatedAnswers,
            revealedIndices: updatedRevealed,
            correctOptionIds: updatedCorrectOptionIds,
          ),
        );
        return;
      }
      emit(McqExamError(e.toString()));
    }
  }

  void _onNext(McqNextPressed event, Emitter<McqExamState> emit) {
    final current = state;
    if (current is! McqExamInProgress || !current.canGoNext) return;
    emit(current.copyWith(currentIndex: current.currentIndex + 1));
  }

  void _onPrevious(McqPreviousPressed event, Emitter<McqExamState> emit) {
    final current = state;
    if (current is! McqExamInProgress || !current.canGoPrevious) return;
    emit(current.copyWith(currentIndex: current.currentIndex - 1));
  }

  Future<void> _onFinish(McqFinishPressed event, Emitter<McqExamState> emit) async {
    final current = state;
    if (current is! McqExamInProgress || !current.canFinish) return;

    _timer?.cancel();
    emit(const McqExamLoading());
    try {
      // Complete stage on server
      final completeResponse = await _completeMcqStage(current.session.stageId);
      
      final result = McqCompleteResult(
        scorePercent: completeResponse.scorePercent,
        isPass: completeResponse.scorePercent >= 60,
        correctCount: completeResponse.correctCount,
        totalCount: completeResponse.totalQuestions,
        topics: const [],
      );
      
      emit(McqExamFinished(examState: current, result: result));
    } catch (e) {
      emit(McqExamError(e.toString()));
    }
  }

  void _onTimerTicked(McqTimerTicked event, Emitter<McqExamState> emit) {
    final current = state;
    if (current is! McqExamInProgress) return;

    if (current.remainingSeconds <= 1) {
      _timer?.cancel();
      emit(McqExamTimeUp(current.session, current.selectedAnswers));
      return;
    }
    emit(current.copyWith(remainingSeconds: current.remainingSeconds - 1));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const McqTimerTicked()),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
