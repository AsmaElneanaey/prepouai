import 'package:equatable/equatable.dart';

class McqCompleteResponse extends Equatable {
  const McqCompleteResponse({
    required this.score,
    required this.badge,
  });

  final int score;
  final String badge;

  @override
  List<Object?> get props => [score, badge];
}
