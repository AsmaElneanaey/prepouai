import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_hr_interview.dart';
import 'hr_interview_event.dart';
import 'hr_interview_state.dart';

class HrInterviewBloc extends Bloc<HrInterviewEvent, HrInterviewState> {
  HrInterviewBloc(this._getHrInterview) : super(const HrInterviewInitial()) {
    on<HrInterviewRequested>(_onRequested);
  }

  final GetHrInterviewUseCase _getHrInterview;

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
}
