import '../../domain/entities/skill.dart';

class SkillModel {
  const SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String category;
  final String description;

  Skill toEntity() {
    return Skill(
      id: id,
      name: name,
      category: category,
      description: description,
    );
  }
}

class CreateSkillResponseDto {
  const CreateSkillResponseDto({
    required this.success,
    required this.message,
    required this.skill,
  });

  factory CreateSkillResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateSkillResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      skill: SkillModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final SkillModel skill;
}
