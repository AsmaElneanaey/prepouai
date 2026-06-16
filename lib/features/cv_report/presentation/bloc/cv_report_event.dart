import 'package:equatable/equatable.dart';

abstract class CvReportEvent extends Equatable {
  const CvReportEvent();

  @override
  List<Object?> get props => [];
}

class CvReportRequested extends CvReportEvent {
  const CvReportRequested({this.cvFileName, this.fileSizeBytes, this.stageId});

  final String? cvFileName;
  final int? fileSizeBytes;
  final String? stageId;

  @override
  List<Object?> get props => [cvFileName, fileSizeBytes, stageId];
}
