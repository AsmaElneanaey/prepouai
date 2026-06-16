import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  const Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
  });

  final String id;
  final String name;
  final String category;
  final String description;

  @override
  List<Object?> get props => [id, name, category, description];
}
