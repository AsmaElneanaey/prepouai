import 'package:equatable/equatable.dart';

class StageScore extends Equatable {
  const StageScore({
    required this.stageName,
    required this.score,
    required this.feedback,
    required this.iconKey,
  });

  final String stageName;
  final int score;
  final String feedback;
  final String iconKey;

  @override
  List<Object?> get props => [stageName, score, feedback, iconKey];
}
