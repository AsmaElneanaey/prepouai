import 'package:equatable/equatable.dart';

abstract class FinalReportEvent extends Equatable {
  const FinalReportEvent();

  @override
  List<Object?> get props => [];
}

class FinalReportRequested extends FinalReportEvent {
  const FinalReportRequested();
}
