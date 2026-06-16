import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hr_message.dart';
import '../../domain/usecases/get_hr_interview.dart';
import '../../domain/usecases/submit_hr_response_use_case.dart';
import 'hr_interview_event.dart';
import 'hr_interview_state.dart';

class HrInterviewBloc extends Bloc<HrInterviewEvent, HrInterviewState> {
  HrInterviewBloc(
    this._getHrInterview,
    this._submitHrResponse,
  ) : super(const HrInterviewInitial()) {
    on<HrInterviewRequested>(_onRequested);
    on<HrResponseSubmitted>(_onResponseSubmitted);
  }

  final GetHrInterviewUseCase _getHrInterview;
  final SubmitHrResponseUseCase _submitHrResponse;

  Future<void> _onRequested(
    HrInterviewRequested event,
    Emitter<HrInterviewState> emit,
  ) async {
    emit(const HrInterviewLoading());
    try {
      final session = await _getHrInterview();
      emit(HrInterviewLoaded(session));
    } catch (e) {
      emit(HrInterviewError(e.toString()));
    }
  }

  Future<void> _onResponseSubmitted(
    HrResponseSubmitted event,
    Emitter<HrInterviewState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HrInterviewLoaded) return;

    emit(HrInterviewLoaded(currentState.session, isSubmitting: true));
    try {
      final response = await _submitHrResponse(
        id: currentState.session.stageId,
        responseText: event.responseText,
      );

      final updatedMessages = List<HrInterviewMessage>.from(currentState.session.messages)
        ..add(response.userMessage);

      if (!response.completed) {
        updatedMessages.add(response.aiReplyMessage);

        final updatedSession = currentState.session.copyWith(
          messages: updatedMessages,
          liveQuestionCue: response.nextQuestion ?? '',
        );
        emit(HrInterviewLoaded(updatedSession, isSubmitting: false));
      } else {
        final updatedSession = currentState.session.copyWith(
          messages: updatedMessages,
          liveQuestionCue: 'Interview Completed!',
        );
        emit(HrInterviewCompleted(updatedSession));
      }
    } catch (e) {
      emit(HrInterviewError(e.toString()));
    }
  }
}
