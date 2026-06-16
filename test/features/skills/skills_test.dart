import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/skills/data/models/skill_model.dart';
import 'package:prepouai/features/skills/data/repositories/skills_repository_impl.dart';
import 'package:prepouai/features/skills/data/datasources/skills_remote_data_source.dart';
import 'package:prepouai/features/skills/domain/entities/skill.dart';
import 'package:prepouai/features/skills/domain/usecases/create_skill_use_case.dart';

class FakeSkillsRemoteDataSource implements SkillsRemoteDataSource {
  FakeSkillsRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<CreateSkillResponseDto> createSkill({
    required String name,
    required String category,
    required String description,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return CreateSkillResponseDto.fromJson({
      'success': true,
      'message': 'Skill created successfully',
      'data': {
        '_id': 'skill-12345',
        'name': name,
        'category': category,
        'description': description,
      }
    });
  }
}

void main() {
  group('Skills Clean Architecture Test Suite', () {
    test('SkillsRepositoryImpl maps data model to domain entity correctly', () async {
      final fakeDs = FakeSkillsRemoteDataSource(shouldSucceed: true);
      final repository = SkillsRepositoryImpl(fakeDs);

      final Skill skill = await repository.createSkill(
        name: 'NestJS',
        category: 'Backend',
        description: 'A progressive Node.js framework.',
      );

      expect(skill.id, 'skill-12345');
      expect(skill.name, 'NestJS');
      expect(skill.category, 'Backend');
      expect(skill.description, 'A progressive Node.js framework.');
    });

    test('SkillsRepositoryImpl forwards errors correctly', () async {
      final fakeDs = FakeSkillsRemoteDataSource(shouldSucceed: false);
      final repository = SkillsRepositoryImpl(fakeDs);

      expect(
        () => repository.createSkill(
          name: 'NestJS',
          category: 'Backend',
          description: 'A progressive Node.js framework.',
        ),
        throwsException,
      );
    });

    test('CreateSkillUseCase executes command to repository successfully', () async {
      final fakeDs = FakeSkillsRemoteDataSource(shouldSucceed: true);
      final repository = SkillsRepositoryImpl(fakeDs);
      final useCase = CreateSkillUseCase(repository);

      final Skill skill = await useCase(
        name: 'React',
        category: 'Frontend',
        description: 'A JavaScript library for building user interfaces.',
      );

      expect(skill.name, 'React');
      expect(skill.category, 'Frontend');
      expect(skill.description, 'A JavaScript library for building user interfaces.');
    });
  });
}
