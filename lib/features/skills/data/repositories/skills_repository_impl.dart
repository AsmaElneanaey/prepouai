import '../../domain/entities/skill.dart';
import '../../domain/repositories/skills_repository.dart';
import '../datasources/skills_remote_data_source.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  SkillsRepositoryImpl(this._remoteDataSource);

  final SkillsRemoteDataSource _remoteDataSource;

  @override
  Future<Skill> createSkill({
    required String name,
    required String category,
    required String description,
  }) async {
    final response = await _remoteDataSource.createSkill(
      name: name,
      category: category,
      description: description,
    );
    return response.skill.toEntity();
  }
}
