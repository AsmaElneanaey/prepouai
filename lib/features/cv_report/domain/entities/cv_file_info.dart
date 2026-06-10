import 'package:equatable/equatable.dart';

class CvFileInfo extends Equatable {
  const CvFileInfo({
    required this.fileName,
    required this.fileSizeLabel,
    required this.isParsed,
  });

  final String fileName;
  final String fileSizeLabel;
  final bool isParsed;

  @override
  List<Object?> get props => [fileName, fileSizeLabel, isParsed];
}
