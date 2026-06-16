import 'package:equatable/equatable.dart';

class HrNextQuestion extends Equatable {
  const HrNextQuestion({
    required this.question,
  });

  final String question;

  @override
  List<Object?> get props => [question];
}
