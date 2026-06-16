import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/mcq_exam/data/datasources/mcq_exam_remote_data_source.dart';
import 'package:prepouai/features/mcq_exam/data/models/mcq_exam_model.dart';
import 'package:prepouai/features/mcq_exam/data/models/mcq_stage_models.dart';
import 'package:prepouai/features/mcq_exam/data/repositories/mcq_exam_repository_impl.dart';
import 'package:prepouai/features/mcq_exam/domain/entities/mcq_exam_session.dart';
import 'package:prepouai/features/mcq_exam/domain/entities/mcq_answer_response.dart';
import 'package:prepouai/features/mcq_exam/domain/entities/mcq_complete_response.dart';
import 'package:prepouai/features/mcq_exam/domain/usecases/start_mcq_stage_use_case.dart';
import 'package:prepouai/features/mcq_exam/domain/usecases/submit_mcq_answer_use_case.dart';
import 'package:prepouai/features/mcq_exam/domain/usecases/complete_mcq_stage_use_case.dart';

class FakeMcqExamRemoteDataSource implements McqExamRemoteDataSource {
  FakeMcqExamRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<McqExamModel> fetchExamSession() async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return McqExamModel(
      questions: const [
        {
          'category': 'React',
          'difficulty': 'medium',
          'text': 'Sync with external system?',
          'options': [
            {'id': 'A', 'label': 'useState'},
            {'id': 'B', 'label': 'useEffect'},
            {'id': 'C', 'label': 'useRef'},
            {'id': 'D', 'label': 'useMemo'},
          ],
          'correctOptionId': 'B',
          'explanation': 'useEffect hook.',
        }
      ],
      durationSeconds: 20 * 60,
    );
  }

  @override
  Future<StartMcqResponseDto> startMcqStage(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return StartMcqResponseDto.fromJson({
      'success': true,
      'message': 'MCQ exam session started successfully',
      'data': {
        'questions': [
          {
            'category': 'React',
            'difficulty': 'medium',
            'text': 'Sync with external system?',
            'options': [
              {'id': 'A', 'label': 'useState'},
              {'id': 'B', 'label': 'useEffect'},
              {'id': 'C', 'label': 'useRef'},
              {'id': 'D', 'label': 'useMemo'},
            ],
            'correctOptionId': 'B',
            'explanation': 'useEffect hook.',
          }
        ],
        'durationSeconds': 1200
      }
    });
  }

  @override
  Future<McqAnswerResponseDto> submitAnswer({
    required String id,
    required String questionId,
    required int selectedOptionIndex,
    required int timeSpentSeconds,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return McqAnswerResponseDto.fromJson({
      'success': true,
      'message': 'Answer submitted successfully',
      'data': {
        'isCorrect': true,
        'explanation': 'Correct answer explanation.'
      }
    });
  }

  @override
  Future<McqCompleteResponseDto> completeMcqStage(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return McqCompleteResponseDto.fromJson({
      'success': true,
      'message': 'MCQ stage completed successfully',
      'data': {
        'score': 80,
        'badge': 'Strong'
      }
    });
  }
}

void main() {
  group('MCQ Exam Clean Architecture Test Suite', () {
    test('getExamSession returns questions correctly mapped', () async {
      final fakeDs = FakeMcqExamRemoteDataSource(shouldSucceed: true);
      final repository = McqExamRepositoryImpl(fakeDs);
      final session = await repository.getExamSession();

      expect(session.totalQuestions, 1);
      expect(session.durationSeconds, 20 * 60);
      expect(session.questions.first.category, 'React');
      expect(session.questions.first.options, hasLength(4));
    });

    test('startMcqStage returns valid McqExamSession entity', () async {
      final fakeDs = FakeMcqExamRemoteDataSource(shouldSucceed: true);
      final repository = McqExamRepositoryImpl(fakeDs);
      final useCase = StartMcqStageUseCase(repository);

      final McqExamSession session = await useCase('session-123');

      expect(session.totalQuestions, 1);
      expect(session.durationSeconds, 1200);
      expect(session.questions.first.text, 'Sync with external system?');
    });

    test('submitAnswer returns valid McqAnswerResponse entity', () async {
      final fakeDs = FakeMcqExamRemoteDataSource(shouldSucceed: true);
      final repository = McqExamRepositoryImpl(fakeDs);
      final useCase = SubmitMcqAnswerUseCase(repository);

      final McqAnswerResponse response = await useCase(
        id: 'session-123',
        questionId: 'q-456',
        selectedOptionIndex: 1,
        timeSpentSeconds: 15,
      );

      expect(response.isCorrect, true);
      expect(response.explanation, 'Correct answer explanation.');
    });

    test('completeMcqStage returns valid McqCompleteResponse entity', () async {
      final fakeDs = FakeMcqExamRemoteDataSource(shouldSucceed: true);
      final repository = McqExamRepositoryImpl(fakeDs);
      final useCase = CompleteMcqStageUseCase(repository);

      final McqCompleteResponse response = await useCase('session-123');

      expect(response.score, 80);
      expect(response.badge, 'Strong');
    });
  });
}
