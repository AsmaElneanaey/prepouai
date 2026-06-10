import 'package:equatable/equatable.dart';

class TopicBreakdown extends Equatable {
  const TopicBreakdown({
    required this.name,
    required this.correct,
    required this.total,
  });

  final String name;
  final int correct;
  final int total;

  bool get isPerfect => correct == total;

  @override
  List<Object?> get props => [name, correct, total];
}
