import 'package:equatable/equatable.dart';

class ReportShareResponse extends Equatable {
  const ReportShareResponse({
    required this.token,
  });

  final String token;

  @override
  List<Object?> get props => [token];
}
