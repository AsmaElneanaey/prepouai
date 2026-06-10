import 'package:equatable/equatable.dart';

import 'topic_breakdown.dart';

export 'topic_breakdown.dart';

class McqCompleteResult extends Equatable {
  const McqCompleteResult({
    required this.scorePercent,
    required this.isPass,
    required this.correctCount,
    required this.totalCount,
    required this.topics,
  });

  final int scorePercent;
  final bool isPass;
  final int correctCount;
  final int totalCount;
  final List<TopicBreakdown> topics;

  @override
  List<Object?> get props => [
        scorePercent,
        isPass,
        correctCount,
        totalCount,
        topics,
      ];
}
