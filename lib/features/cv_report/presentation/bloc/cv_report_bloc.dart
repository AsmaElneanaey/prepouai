import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_cv_report.dart';
import 'cv_report_event.dart';
import 'cv_report_state.dart';

class CvReportBloc extends Bloc<CvReportEvent, CvReportState> {
  CvReportBloc(this._getCvReport) : super(const CvReportInitial()) {
    on<CvReportRequested>(_onRequested);
  }

  final GetCvReportUseCase _getCvReport;

  Future<void> _onRequested(
    CvReportRequested event,
    Emitter<CvReportState> emit,
  ) async {
    emit(const CvReportLoading());
    try {
      final report = await _getCvReport(
        cvFileName: event.cvFileName,
        fileSizeBytes: event.fileSizeBytes,
        stageId: event.stageId,
      );
      emit(CvReportLoaded(report));
    } catch (e) {
      emit(CvReportError(e.toString()));
    }
  }
}
