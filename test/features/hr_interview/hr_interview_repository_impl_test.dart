import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/hr_interview/data/datasources/hr_interview_remote_data_source.dart';
import 'package:prepouai/features/hr_interview/data/models/hr_interview_session_model.dart';
import 'package:prepouai/features/hr_interview/data/models/hr_stage_models.dart';
import 'package:prepouai/features/hr_interview/data/repositories/hr_interview_repository_impl.dart';
import 'package:prepouai/features/hr_interview/domain/entities/hr_message.dart';
import 'package:prepouai/features/hr_interview/domain/entities/hr_submit_response.dart';
import 'package:prepouai/features/hr_interview/domain/entities/hr_next_question.dart';
import 'package:prepouai/features/hr_interview/domain/usecases/start_hr_interview_stage_use_case.dart';
import 'package:prepouai/features/hr_interview/domain/usecases/submit_hr_response_use_case.dart';
import 'package:prepouai/features/hr_interview/domain/usecases/get_hr_next_question_use_case.dart';

class FakeHrInterviewRemoteDataSource implements HrInterviewRemoteDataSource {
  FakeHrInterviewRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<HrInterviewSessionModel> fetchActiveSession() async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return HrInterviewSessionModel(
      headerTimerLabel: '0:02',
      interviewerName: 'PrepYou AI',
      interviewerRole: 'HR Interviewer',
      liveQuestionCue: '"Tell me about yourself."',
      messages: const [
        {
          'sender': 'ai',
          'body': 'Hello! Let\'s start.',
          'timestamp': '0:00',
        }
      ],
    );
  }

  @override
  Future<StartHrResponseDto> startHrStage(String id, String focusArea) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return StartHrResponseDto.fromJson(const {
      'success': true,
      'message': 'HR stage started successfully',
    });
  }

  @override
  Future<HrSubmitResponseDto> submitResponse({
    required String id,
    required String responseText,
    String? audioRecordingUrl,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return HrSubmitResponseDto.fromJson({
      'success': true,
      'message': 'Response submitted successfully',
      'data': {
        'user_message': {
          'sender': 'user',
          'body': responseText,
          'timestamp': '0:32',
        },
        'ai_reply_message': {
          'sender': 'ai',
          'body': 'Thank you for your response.',
          'timestamp': '1:05',
        }
      }
    });
  }

  @override
  Future<HrNextQuestionDto> getNextQuestion(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return HrNextQuestionDto.fromJson(const {
      'success': true,
      'message': 'Next question retrieved',
      'data': {
        'question': 'Tell me about a time you led a team.',
      }
    });
  }
}

void main() {
  group('HR Interview Clean Architecture Test Suite', () {
    test('getActiveSession returns mock transcript', () async {
      final fakeDs = FakeHrInterviewRemoteDataSource(shouldSucceed: true);
      final repository = HrInterviewRepositoryImpl(fakeDs);
      final session = await repository.getActiveSession();

      expect(session.messages.length, 1);
      expect(session.messages.first.sender, HrMessageSender.ai);
      expect(session.liveQuestionCue, '"Tell me about yourself."');
    });

    test('startHrInterviewStage successfully executes', () async {
      final fakeDs = FakeHrInterviewRemoteDataSource(shouldSucceed: true);
      final repository = HrInterviewRepositoryImpl(fakeDs);
      final useCase = StartHrInterviewStageUseCase(repository);

      await expectLater(
        useCase(id: 'session-123', focusArea: 'Behavioral'),
        completes,
      );
    });

    test('submitResponse returns valid HrSubmitResponse entity', () async {
      final fakeDs = FakeHrInterviewRemoteDataSource(shouldSucceed: true);
      final repository = HrInterviewRepositoryImpl(fakeDs);
      final useCase = SubmitHrResponseUseCase(repository);

      final HrSubmitResponse response = await useCase(
        id: 'session-123',
        responseText: 'I resolved a conflict by listening to both sides...',
        audioRecordingUrl: 'https://storage.com/audio.mp3',
      );

      expect(response.userMessage.body, 'I resolved a conflict by listening to both sides...');
      expect(response.userMessage.sender, HrMessageSender.user);
      expect(response.aiReplyMessage.body, 'Thank you for your response.');
      expect(response.aiReplyMessage.sender, HrMessageSender.ai);
    });

    test('getNextQuestion returns valid HrNextQuestion entity', () async {
      final fakeDs = FakeHrInterviewRemoteDataSource(shouldSucceed: true);
      final repository = HrInterviewRepositoryImpl(fakeDs);
      final useCase = GetHrNextQuestionUseCase(repository);

      final HrNextQuestion result = await useCase('session-123');

      expect(result.question, 'Tell me about a time you led a team.');
    });
  });
}
