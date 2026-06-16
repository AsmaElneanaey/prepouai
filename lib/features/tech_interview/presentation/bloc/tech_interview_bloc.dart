import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_tech_interview.dart';
import '../../domain/usecases/submit_code.dart';
import '../../domain/usecases/complete_tech_interview_stage_use_case.dart';
import '../../domain/usecases/send_tech_chat_message_use_case.dart';
import 'tech_interview_event.dart';
import 'tech_interview_state.dart';
import '../../domain/entities/tech_interview_session.dart';

class TechInterviewBloc extends Bloc<TechInterviewEvent, TechInterviewState> {
  TechInterviewBloc(
    this._getTechInterview,
    this._submitCode,
    this._completeTechStage,
    this._sendTechChatMessage,
  ) : super(const TechInterviewInitial()) {
    on<TechInterviewRequested>(_onRequested);
    on<CodeChanged>(_onCodeChanged);
    on<LanguageChanged>(_onLanguageChanged);
    on<SubmitCodePressed>(_onSubmitCodePressed);
    on<SendMessagePressed>(_onSendMessagePressed);
  }

  final GetTechInterviewUseCase _getTechInterview;
  final SubmitCodeUseCase _submitCode;
  final CompleteTechInterviewStageUseCase _completeTechStage;
  final SendTechChatMessageUseCase _sendTechChatMessage;

  Future<void> _onRequested(
    TechInterviewRequested event,
    Emitter<TechInterviewState> emit,
  ) async {
    emit(const TechInterviewLoading());
    try {
      final session = await _getTechInterview();
      emit(TechInterviewLoaded(
        session: session,
        currentCode: session.question.starterCode,
        currentLanguage: session.question.language,
        terminalOutput: '// Ready to run tests...',
        isSubmitting: false,
        isSuccess: false,
      ));
    } catch (e) {
      emit(TechInterviewError(e.toString()));
    }
  }

  void _onCodeChanged(
    CodeChanged event,
    Emitter<TechInterviewState> emit,
  ) {
    final s = state;
    if (s is TechInterviewLoaded) {
      emit(s.copyWith(currentCode: event.code));
    }
  }

  void _onLanguageChanged(
    LanguageChanged event,
    Emitter<TechInterviewState> emit,
  ) {
    final s = state;
    if (s is TechInterviewLoaded) {
      emit(s.copyWith(currentLanguage: event.language));
    }
  }

  Future<void> _onSubmitCodePressed(
    SubmitCodePressed event,
    Emitter<TechInterviewState> emit,
  ) async {
    final s = state;
    if (s is TechInterviewLoaded) {
      emit(s.copyWith(isSubmitting: true, terminalOutput: '[Compiling and running tests...]'));
      try {
        final result = await _submitCode(
          techInterviewId: s.session.stageId,
          problemId: s.session.question.id,
          code: s.currentCode,
          language: s.currentLanguage,
        );
        final isAllPassed = result.contains('All tests passed!');

        if (isAllPassed) {
          // Trigger the complete API on the backend when tests pass
          await _completeTechStage(s.session.stageId);
        }

        List<TechChatMessage> updatedMessages = List.from(s.session.messages);
        if (isAllPassed) {
          updatedMessages.add(const TechChatMessage(
            sender: TechMessageSender.ai,
            body: "Excellent solution! You've successfully passed all the test cases. Feel free to continue to the Final Report dashboard to review your comprehensive score.",
            timestampLabel: '0:45',
          ));
        } else {
          updatedMessages.add(const TechChatMessage(
            sender: TechMessageSender.ai,
            body: "Some test cases failed. Take a look at the console output and check edge cases (e.g. negative numbers, empty arrays).",
            timestampLabel: '0:30',
          ));
        }

        final updatedSession = s.session.copyWith(messages: updatedMessages);

        emit(s.copyWith(
          isSubmitting: false,
          terminalOutput: result,
          isSuccess: isAllPassed,
          session: updatedSession,
        ));
      } catch (e) {
        emit(s.copyWith(
          isSubmitting: false,
          terminalOutput: 'Error: ${e.toString()}',
          isSuccess: false,
        ));
      }
    }
  }

  Future<void> _onSendMessagePressed(
    SendMessagePressed event,
    Emitter<TechInterviewState> emit,
  ) async {
    final s = state;
    if (s is TechInterviewLoaded) {
      final userMsg = TechChatMessage(
        sender: TechMessageSender.user,
        body: event.body,
        timestampLabel: '0:18',
      );

      List<TechChatMessage> updatedMessages = List.from(s.session.messages)..add(userMsg);

      final updatedSession = s.session.copyWith(messages: updatedMessages);

      emit(s.copyWith(session: updatedSession));

      try {
        final aiResponse = await _sendTechChatMessage(
          id: s.session.stageId,
          message: event.body,
        );

        final aiMsg = TechChatMessage(
          sender: TechMessageSender.ai,
          body: aiResponse,
          timestampLabel: '0:20',
        );

        final nextState = state;
        if (nextState is TechInterviewLoaded) {
          final finalMessages = List<TechChatMessage>.from(nextState.session.messages)..add(aiMsg);
          emit(nextState.copyWith(
            session: nextState.session.copyWith(messages: finalMessages),
          ));
        }
      } catch (e) {
        final errorMsg = TechChatMessage(
          sender: TechMessageSender.ai,
          body: 'Error: ${e.toString()}',
          timestampLabel: '0:20',
        );
        final nextState = state;
        if (nextState is TechInterviewLoaded) {
          emit(nextState.copyWith(
            session: nextState.session.copyWith(
              messages: List.from(nextState.session.messages)..add(errorMsg),
            ),
          ));
        }
      }
    }
  }
}
