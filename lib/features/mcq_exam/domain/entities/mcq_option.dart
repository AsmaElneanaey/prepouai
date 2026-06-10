import 'package:equatable/equatable.dart';

class McqOption extends Equatable {
  const McqOption({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}
