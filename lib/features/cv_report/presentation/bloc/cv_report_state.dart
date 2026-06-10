import 'package:equatable/equatable.dart';

import '../../domain/entities/cv_report.dart';

abstract class CvReportState extends Equatable {
  const CvReportState();

  @override
  List<Object?> get props => [];
}

class CvReportInitial extends CvReportState {
  const CvReportInitial();
}

class CvReportLoading extends CvReportState {
  const CvReportLoading();
}

class CvReportLoaded extends CvReportState {
  const CvReportLoaded(this.report);

  final CvReport report;

  @override
  List<Object?> get props => [report];
}

class CvReportError extends CvReportState {
  const CvReportError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
