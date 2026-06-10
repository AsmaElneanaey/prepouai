import 'package:equatable/equatable.dart';

enum SkillBarColor { blue, green, purple, yellow, red }

class SkillBreakdown extends Equatable {
  const SkillBreakdown({
    required this.name,
    required this.percent,
    required this.barColor,
  });

  final String name;
  final int percent;
  final SkillBarColor barColor;

  @override
  List<Object?> get props => [name, percent, barColor];
}
