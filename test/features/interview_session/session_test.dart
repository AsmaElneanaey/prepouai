import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/interview_session/data/models/session_model.dart';
import 'package:prepouai/features/interview_session/data/repositories/session_repository_impl.dart';
import 'package:prepouai/features/interview_session/data/datasources/session_remote_data_source.dart';
import 'package:prepouai/features/interview_session/domain/entities/interview_session.dart';
import 'package:prepouai/features/interview_session/domain/usecases/create_session_use_case.dart';
import 'package:prepouai/features/interview_session/domain/usecases/get_user_sessions_use_case.dart';
import 'package:prepouai/features/interview_session/domain/usecases/get_session_details_use_case.dart';
import 'package:prepouai/features/interview_session/domain/usecases/get_current_stage_use_case.dart';
import 'package:prepouai/features/interview_session/domain/usecases/get_pipeline_stages_use_case.dart';
import 'package:prepouai/features/interview_session/domain/usecases/update_stage_status_use_case.dart';

class FakeSessionRemoteDataSource implements SessionRemoteDataSource {
  FakeSessionRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<CreateSessionResponseDto> createSession({
    required String targetRole,
    required String seniorityLevel,
    required String targetCompanyId,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return CreateSessionResponseDto.fromJson({
      'success': true,
      'message': 'Interview session created successfully',
      'data': {
        'user_id': '65f123456789abcdefabcdef',
        'session_number': 1,
        'title': 'Google L4 — Senior Frontend Engineer',
        'target_role': targetRole,
        'seniority_level': seniorityLevel,
        'target_company_id': targetCompanyId,
        'status': 'active',
        'collected_badges': [],
        'started_at': '2026-06-01T14:00:00.000Z',
        '_id': '65f1aaaabbbbccccddddeeee',
        'createdAt': '2026-06-01T14:00:00.000Z',
        'updatedAt': '2026-06-01T14:00:00.000Z',
        'stages': []
      }
    });
  }

  @override
  Future<GetSessionsResponseDto> getUserSessions() async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return GetSessionsResponseDto.fromJson({
      'success': true,
      'message': 'User interview sessions fetched successfully',
      'data': [
        {
          '_id': '65f1aaaabbbbccccddddeeee',
          'user_id': '65f123456789abcdefabcdef',
          'session_number': 1,
          'title': 'Google L4 — Senior Frontend Engineer',
          'target_role': 'Frontend Engineer',
          'seniority_level': 'Senior',
          'target_company_id': '65f199887766554433221100',
          'status': 'active',
          'collected_badges': [],
          'started_at': '2026-06-01T14:00:00.000Z',
          'createdAt': '2026-06-01T14:00:00.000Z',
          'updatedAt': '2026-06-01T14:00:00.000Z',
          'stages': [
            {
              '_id': '65f1bbbbaaaaccccddddeeee',
              'session_id': '65f1aaaabbbbccccddddeeee',
              'stage_type': 'cv_upload',
              'order_index': 1,
              'status': 'active',
              'started_at': '2026-06-01T14:00:00.000Z'
            }
          ]
        }
      ]
    });
  }

  @override
  Future<GetSessionDetailsResponseDto> getSessionDetails(String sessionId) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return GetSessionDetailsResponseDto.fromJson({
      'success': true,
      'message': 'Interview session details fetched successfully',
      'data': {
        '_id': sessionId,
        'user_id': '65f123456789abcdefabcdef',
        'session_number': 1,
        'title': 'Google L4 — Senior Frontend Engineer',
        'target_role': 'Frontend Engineer',
        'seniority_level': 'Senior',
        'status': 'active',
        'collected_badges': [],
        'started_at': '2026-06-01T14:00:00.000Z',
        'createdAt': '2026-06-01T14:00:00.000Z',
        'updatedAt': '2026-06-01T14:00:00.000Z',
        'stages': [
          {
            '_id': '65f1bbbbaaaaccccddddeeee',
            'session_id': sessionId,
            'stage_type': 'cv_upload',
            'order_index': 1,
            'status': 'completed',
            'started_at': '2026-06-01T14:00:00.000Z',
            'completed_at': '2026-06-01T14:15:00.000Z',
            'score': 90,
            'badge': 'Strong'
          }
        ]
      }
    });
  }

  @override
  Future<GetCurrentStageResponseDto> getCurrentStage(String sessionId) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return GetCurrentStageResponseDto.fromJson({
      'success': true,
      'message': 'Active pipeline stage fetched successfully',
      'data': {
        '_id': '65f1ccccaaaabbbbddddeeee',
        'session_id': sessionId,
        'stage_type': 'mcq',
        'order_index': 2,
        'status': 'active',
        'started_at': '2026-06-01T14:15:00.000Z'
      }
    });
  }

  @override
  Future<GetPipelineStagesResponseDto> getPipelineStages(String sessionId) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return GetPipelineStagesResponseDto.fromJson({
      'success': true,
      'message': 'List of pipeline stages retrieved successfully.',
      'data': [
        {
          '_id': '65f1bbbbaaaaccccddddeeee',
          'session_id': sessionId,
          'stage_type': 'cv_upload',
          'order_index': 1,
          'status': 'completed',
          'started_at': '2026-06-01T14:00:00.000Z',
          'completed_at': '2026-06-01T14:15:00.000Z',
          'score': 90,
          'badge': 'Strong'
        },
        {
          '_id': '65f1ccccaaaabbbbddddeeee',
          'session_id': sessionId,
          'stage_type': 'mcq',
          'order_index': 2,
          'status': 'active',
          'started_at': '2026-06-01T14:15:00.000Z'
        }
      ]
    });
  }

  @override
  Future<UpdateStageStatusResponseDto> updateStageStatus({
    required String stageId,
    required String status,
    int? score,
    String? badge,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return UpdateStageStatusResponseDto.fromJson({
      'success': true,
      'message': 'Stage status successfully updated.',
      'data': {
        '_id': stageId,
        'session_id': '65f1aaaabbbbccccddddeeee',
        'stage_type': 'cv_upload',
        'order_index': 1,
        'status': status,
        'started_at': '2026-06-01T14:00:00.000Z',
        'completed_at': '2026-06-01T14:15:00.000Z',
        // ignore: use_null_aware_elements
        if (score != null) 'score': score,
        // ignore: use_null_aware_elements
        if (badge != null) 'badge': badge,
      }
    });
  }
}

void main() {
  group('Session Clean Architecture Test Suite', () {
    test('SessionRepositoryImpl maps data model to domain entity correctly', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: true);
      final repository = SessionRepositoryImpl(fakeDs);

      final InterviewSession session = await repository.createSession(
        targetRole: 'Frontend Engineer',
        seniorityLevel: 'Senior',
        targetCompanyId: '65f199887766554433221100',
      );

      expect(session.id, '65f1aaaabbbbccccddddeeee');
      expect(session.userId, '65f123456789abcdefabcdef');
      expect(session.title, 'Google L4 — Senior Frontend Engineer');
      expect(session.targetRole, 'Frontend Engineer');
      expect(session.seniorityLevel, 'Senior');
      expect(session.targetCompanyId, '65f199887766554433221100');
      expect(session.status, 'active');
    });

    test('SessionRepositoryImpl forwards errors correctly', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: false);
      final repository = SessionRepositoryImpl(fakeDs);

      expect(
        () => repository.createSession(
          targetRole: 'Frontend Engineer',
          seniorityLevel: 'Senior',
          targetCompanyId: '65f199887766554433221100',
        ),
        throwsException,
      );
    });

    test('CreateSessionUseCase executes command to repository successfully', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: true);
      final repository = SessionRepositoryImpl(fakeDs);
      final useCase = CreateSessionUseCase(repository);

      final InterviewSession session = await useCase(
        targetRole: 'Backend Engineer',
        seniorityLevel: 'Mid',
        targetCompanyId: '65f199887766554433221101',
      );

      expect(session.targetRole, 'Backend Engineer');
      expect(session.seniorityLevel, 'Mid');
      expect(session.targetCompanyId, '65f199887766554433221101');
    });

    test('GetUserSessionsUseCase retrieves sessions and maps nested stages correctly', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: true);
      final repository = SessionRepositoryImpl(fakeDs);
      final useCase = GetUserSessionsUseCase(repository);

      final List<InterviewSession> sessions = await useCase();

      expect(sessions.length, 1);
      final session = sessions.first;
      expect(session.title, 'Google L4 — Senior Frontend Engineer');
      expect(session.stages.length, 1);
      
      final stage1 = session.stages[0];
      expect(stage1.id, '65f1bbbbaaaaccccddddeeee');
      expect(stage1.stageType, 'cv_upload');
      expect(stage1.orderIndex, 1);
      expect(stage1.status, 'active');
      expect(stage1.startedAt, '2026-06-01T14:00:00.000Z');
    });

    test('GetSessionDetailsUseCase retrieves specific session details with extra stage metadata', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: true);
      final repository = SessionRepositoryImpl(fakeDs);
      final useCase = GetSessionDetailsUseCase(repository);

      final InterviewSession session = await useCase('65f1aaaabbbbccccddddeeee');

      expect(session.id, '65f1aaaabbbbccccddddeeee');
      expect(session.stages.length, 1);

      final stage1 = session.stages[0];
      expect(stage1.id, '65f1bbbbaaaaccccddddeeee');
      expect(stage1.status, 'completed');
      expect(stage1.completedAt, '2026-06-01T14:15:00.000Z');
      expect(stage1.score, 90);
      expect(stage1.badge, 'Strong');
    });

    test('GetCurrentStageUseCase retrieves active stage for target session successfully', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: true);
      final repository = SessionRepositoryImpl(fakeDs);
      final useCase = GetCurrentStageUseCase(repository);

      final SessionStage stage = await useCase('65f1aaaabbbbccccddddeeee');

      expect(stage.id, '65f1ccccaaaabbbbddddeeee');
      expect(stage.sessionId, '65f1aaaabbbbccccddddeeee');
      expect(stage.stageType, 'mcq');
      expect(stage.orderIndex, 2);
      expect(stage.status, 'active');
      expect(stage.startedAt, '2026-06-01T14:15:00.000Z');
    });

    test('GetPipelineStagesUseCase retrieves all stages for target session successfully', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: true);
      final repository = SessionRepositoryImpl(fakeDs);
      final useCase = GetPipelineStagesUseCase(repository);

      final List<SessionStage> stages = await useCase('65f1aaaabbbbccccddddeeee');

      expect(stages.length, 2);
      expect(stages[0].id, '65f1bbbbaaaaccccddddeeee');
      expect(stages[0].status, 'completed');
      expect(stages[0].score, 90);
      expect(stages[0].badge, 'Strong');
      expect(stages[1].id, '65f1ccccaaaabbbbddddeeee');
      expect(stages[1].stageType, 'mcq');
      expect(stages[1].status, 'active');
    });

    test('UpdateStageStatusUseCase updates stage details successfully', () async {
      final fakeDs = FakeSessionRemoteDataSource(shouldSucceed: true);
      final repository = SessionRepositoryImpl(fakeDs);
      final useCase = UpdateStageStatusUseCase(repository);

      final SessionStage stage = await useCase(
        stageId: '65f1bbbbaaaaccccddddeeee',
        status: 'completed',
        score: 85,
        badge: 'Strong',
      );

      expect(stage.id, '65f1bbbbaaaaccccddddeeee');
      expect(stage.status, 'completed');
      expect(stage.score, 85);
      expect(stage.badge, 'Strong');
      expect(stage.completedAt, '2026-06-01T14:15:00.000Z');
    });
  });
}
