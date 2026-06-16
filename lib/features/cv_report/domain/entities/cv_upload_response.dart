import 'package:equatable/equatable.dart';

class CvUploadResponse extends Equatable {
  const CvUploadResponse({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.status,
  });

  final String id;
  final String fileName;
  final int fileSize;
  final String status;

  @override
  List<Object?> get props => [id, fileName, fileSize, status];
}
