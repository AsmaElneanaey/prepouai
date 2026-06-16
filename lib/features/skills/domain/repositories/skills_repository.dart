import '../entities/skill.dart';

abstract class SkillsRepository {
  Future<Skill> createSkill({
    required String name,
    required String category,
    required String description,
  });
}
