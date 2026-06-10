import 'package:equatable/equatable.dart';
import '../../domain/entities/final_report.dart';

abstract class FinalReportState extends Equatable {
  const FinalReportState();

  @override
  List<Object?> get props => [];
}

class FinalReportInitial extends FinalReportState {
  const FinalReportInitial();
}

class FinalReportLoading extends FinalReportState {
  const FinalReportLoading();
}

class FinalReportLoaded extends FinalReportState {
  const FinalReportLoaded(this.report);
  final FinalReport report;

  @override
  List<Object?> get props => [report];
}

class FinalReportError extends FinalReportState {
  const FinalReportError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
