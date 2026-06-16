import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/tech_interview/data/datasources/tech_interview_remote_data_source.dart';
import 'package:prepouai/features/tech_interview/data/models/tech_interview_session_model.dart';
import 'package:prepouai/features/tech_interview/data/models/tech_stage_models.dart';
import 'package:prepouai/features/tech_interview/data/repositories/tech_interview_repository_impl.dart';
import 'package:prepouai/features/tech_interview/domain/entities/tech_chat_message.dart';
import 'package:prepouai/features/tech_interview/domain/usecases/start_tech_interview_stage_use_case.dart';
import 'package:prepouai/features/tech_interview/domain/usecases/complete_tech_interview_stage_use_case.dart';

class FakeTechInterviewRemoteDataSource implements TechInterviewRemoteDataSource {
  FakeTechInterviewRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<TechInterviewSessionModel> fetchActiveSession() async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return TechInterviewSessionModel(
      headerTimerLabel: '0:15',
      interviewerName: 'PrepYou AI Code Coach',
      interviewerRole: 'Technical Interviewer',
      questionTitle: 'Two Sum',
      questionDifficulty: 'easy',
      questionLanguage: 'dart',
      questionDescription: 'Write a solution for Two Sum.',
      questionStarterCode: 'List<int> twoSum(...)',
      messages: const [
        {
          'sender': 'ai',
          'body': 'Welcome.',
          'timestamp': '0:00',
        }
      ],
    );
  }

  @override
  Future<String> submitCode(String code, String language) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    if (code.isEmpty) {
      return 'failed';
    }
    return 'All tests passed!';
  }

  @override
  Future<TechStageResponseDto> startTechStage(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return TechStageResponseDto.fromJson(const {
      'success': true,
      'message': 'Tech stage started successfully',
    });
  }

  @override
  Future<TechStageResponseDto> completeTechStage(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return TechStageResponseDto.fromJson(const {
      'success': true,
      'message': 'Tech stage completed successfully',
    });
  }
}

void main() {
  group('Tech Interview Clean Architecture Test Suite', () {
    test('getActiveSession returns mock live coding round details', () async {
      final fakeDs = FakeTechInterviewRemoteDataSource(shouldSucceed: true);
      final repository = TechInterviewRepositoryImpl(fakeDs);
      final session = await repository.getActiveSession();

      expect(session.messages.length, 1);
      expect(session.messages.first.sender, TechMessageSender.ai);
      expect(session.question.title, 'Two Sum');
      expect(session.question.difficulty.name, 'easy');
    });

    test('submitCode returns test failures for empty code submission', () async {
      final fakeDs = FakeTechInterviewRemoteDataSource(shouldSucceed: true);
      final repository = TechInterviewRepositoryImpl(fakeDs);
      final result = await repository.submitCode('', 'dart');

      expect(result, contains('failed'));
    });

    test('submitCode returns test successes for actual solution code submission', () async {
      final fakeDs = FakeTechInterviewRemoteDataSource(shouldSucceed: true);
      final repository = TechInterviewRepositoryImpl(fakeDs);
      final result = await repository.submitCode('// some implementation here', 'dart');

      expect(result, contains('All tests passed!'));
    });

    test('startTechInterviewStage successfully executes', () async {
      final fakeDs = FakeTechInterviewRemoteDataSource(shouldSucceed: true);
      final repository = TechInterviewRepositoryImpl(fakeDs);
      final useCase = StartTechInterviewStageUseCase(repository);

      await expectLater(
        useCase('session-123'),
        completes,
      );
    });

    test('completeTechInterviewStage successfully executes', () async {
      final fakeDs = FakeTechInterviewRemoteDataSource(shouldSucceed: true);
      final repository = TechInterviewRepositoryImpl(fakeDs);
      final useCase = CompleteTechInterviewStageUseCase(repository);

      await expectLater(
        useCase('session-123'),
        completes,
      );
    });
  });
}
