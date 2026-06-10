import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_final_report.dart';
import 'final_report_event.dart';
import 'final_report_state.dart';

class FinalReportBloc extends Bloc<FinalReportEvent, FinalReportState> {
  FinalReportBloc(this._getFinalReport) : super(const FinalReportInitial()) {
    on<FinalReportRequested>(_onRequested);
  }

  final GetFinalReportUseCase _getFinalReport;

  Future<void> _onRequested(
    FinalReportRequested event,
    Emitter<FinalReportState> emit,
  ) async {
    emit(const FinalReportLoading());
    try {
      final report = await _getFinalReport();
      emit(FinalReportLoaded(report));
    } catch (e) {
      emit(FinalReportError(e.toString()));
    }
  }
}
