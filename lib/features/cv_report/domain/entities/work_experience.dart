import 'package:equatable/equatable.dart';

class WorkExperience extends Equatable {
  const WorkExperience({
    required this.title,
    required this.company,
    required this.period,
    required this.description,
    this.isLast = false,
  });

  final String title;
  final String company;
  final String period;
  final String description;
  final bool isLast;

  @override
  List<Object?> get props => [title, company, period, description, isLast];
}
