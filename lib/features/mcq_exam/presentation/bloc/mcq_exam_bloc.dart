import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../mcq_complete/domain/usecases/calculate_mcq_result.dart';
import '../../domain/usecases/get_mcq_exam.dart';
import 'mcq_exam_event.dart';
import 'mcq_exam_state.dart';

class McqExamBloc extends Bloc<McqExamEvent, McqExamState> {
  McqExamBloc(this._getMcqExam, this._calculateMcqResult)
      : super(const McqExamInitial()) {
    on<McqExamRequested>(_onRequested);
    on<McqAnswerSelected>(_onAnswerSelected);
    on<McqNextPressed>(_onNext);
    on<McqPreviousPressed>(_onPrevious);
    on<McqTimerTicked>(_onTimerTicked);
    on<McqFinishPressed>(_onFinish);
  }

  final GetMcqExamUseCase _getMcqExam;
  final CalculateMcqResultUseCase _calculateMcqResult;
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
        ),
      );
      _startTimer();
    } catch (e) {
      emit(McqExamError(e.toString()));
    }
  }

  void _onAnswerSelected(
    McqAnswerSelected event,
    Emitter<McqExamState> emit,
  ) {
    final current = state;
    if (current is! McqExamInProgress) return;
    if (current.isFeedbackVisible) return;

    final updatedAnswers = Map<int, String>.from(current.selectedAnswers)
      ..[current.currentIndex] = event.optionId;
    final updatedRevealed = Set<int>.from(current.revealedIndices)
      ..add(current.currentIndex);

    emit(
      current.copyWith(
        selectedAnswers: updatedAnswers,
        revealedIndices: updatedRevealed,
      ),
    );
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

  void _onFinish(McqFinishPressed event, Emitter<McqExamState> emit) {
    final current = state;
    if (current is! McqExamInProgress || !current.canFinish) return;

    _timer?.cancel();
    final result = _calculateMcqResult(
      session: current.session,
      selectedAnswers: current.selectedAnswers,
    );
    emit(McqExamFinished(examState: current, result: result));
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
