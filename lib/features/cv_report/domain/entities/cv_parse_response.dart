import 'package:equatable/equatable.dart';

class CvParseResponse extends Equatable {
  const CvParseResponse({
    required this.id,
    required this.isParsed,
    required this.status,
  });

  final String id;
  final bool isParsed;
  final String status;

  @override
  List<Object?> get props => [id, isParsed, status];
}
