import '../entities/skill.dart';
import '../repositories/skills_repository.dart';

class CreateSkillUseCase {
  CreateSkillUseCase(this._repository);

  final SkillsRepository _repository;

  Future<Skill> call({
    required String name,
    required String category,
    required String description,
  }) {
    return _repository.createSkill(
      name: name,
      category: category,
      description: description,
    );
  }
}
