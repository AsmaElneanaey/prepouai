import 'package:equatable/equatable.dart';

abstract class CvReportEvent extends Equatable {
  const CvReportEvent();

  @override
  List<Object?> get props => [];
}

class CvReportRequested extends CvReportEvent {
  const CvReportRequested({this.cvFileName, this.fileSizeBytes});

  final String? cvFileName;
  final int? fileSizeBytes;

  @override
  List<Object?> get props => [cvFileName, fileSizeBytes];
}
