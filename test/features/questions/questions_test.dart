import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/questions/data/models/question_model.dart';
import 'package:prepouai/features/questions/data/repositories/questions_repository_impl.dart';
import 'package:prepouai/features/questions/data/datasources/questions_remote_data_source.dart';
import 'package:prepouai/features/questions/domain/entities/master_question.dart';
import 'package:prepouai/features/questions/domain/usecases/create_question_use_case.dart';
import 'package:prepouai/features/questions/domain/usecases/get_questions_use_case.dart';

class FakeQuestionsRemoteDataSource implements QuestionsRemoteDataSource {
  FakeQuestionsRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<CreateQuestionResponseDto> createQuestion({
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
    required String category,
    required String difficulty,
    required List<String> tags,
    required bool isAiGenerated,
    required int estimatedTimeSec,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return CreateQuestionResponseDto.fromJson({
      'success': true,
      'message': 'Question created successfully',
      'data': {
        '_id': 'question-12345',
        'question_text': questionText,
        'options': options,
        'correct_option_index': correctOptionIndex,
        'category': category,
        'difficulty': difficulty,
        'tags': tags,
        'is_ai_generated': isAiGenerated,
        'estimated_time_sec': estimatedTimeSec,
      }
    });
  }

  @override
  Future<GetQuestionsResponseDto> getQuestions() async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }

    return GetQuestionsResponseDto.fromJson({
      'success': true,
      'message': 'Questions fetched successfully',
      'data': [
        {
          '_id': 'question-12345',
          'question_text': 'What is NestJS?',
          'options': ['Framework', 'Database', 'Library', 'OS'],
          'correct_option_index': 0,
          'category': 'Backend',
          'difficulty': 'Easy',
          'tags': ['nestjs', 'node'],
          'is_ai_generated': false,
          'estimated_time_sec': 60,
        }
      ]
    });
  }
}

void main() {
  group('Questions Clean Architecture Test Suite', () {
    test('QuestionsRepositoryImpl maps data model to domain entity correctly', () async {
      final fakeDs = FakeQuestionsRemoteDataSource(shouldSucceed: true);
      final repository = QuestionsRepositoryImpl(fakeDs);

      final MasterQuestion question = await repository.createQuestion(
        questionText: 'What is NestJS?',
        options: ['Framework', 'Database', 'Library', 'OS'],
        correctOptionIndex: 0,
        category: 'Backend',
        difficulty: 'Easy',
        tags: ['nestjs', 'node'],
        isAiGenerated: false,
        estimatedTimeSec: 60,
      );

      expect(question.id, 'question-12345');
      expect(question.questionText, 'What is NestJS?');
      expect(question.options, ['Framework', 'Database', 'Library', 'OS']);
      expect(question.correctOptionIndex, 0);
      expect(question.category, 'Backend');
      expect(question.difficulty, 'Easy');
      expect(question.tags, ['nestjs', 'node']);
      expect(question.isAiGenerated, false);
      expect(question.estimatedTimeSec, 60);
    });

    test('QuestionsRepositoryImpl forwards errors correctly', () async {
      final fakeDs = FakeQuestionsRemoteDataSource(shouldSucceed: false);
      final repository = QuestionsRepositoryImpl(fakeDs);

      expect(
        () => repository.createQuestion(
          questionText: 'What is NestJS?',
          options: ['Framework', 'Database', 'Library', 'OS'],
          correctOptionIndex: 0,
          category: 'Backend',
          difficulty: 'Easy',
          tags: ['nestjs', 'node'],
          isAiGenerated: false,
          estimatedTimeSec: 60,
        ),
        throwsException,
      );
    });

    test('CreateQuestionUseCase executes command to repository successfully', () async {
      final fakeDs = FakeQuestionsRemoteDataSource(shouldSucceed: true);
      final repository = QuestionsRepositoryImpl(fakeDs);
      final useCase = CreateQuestionUseCase(repository);

      final MasterQuestion question = await useCase(
        questionText: 'What is Dart?',
        options: ['Language', 'OS', 'Hardware', 'Database'],
        correctOptionIndex: 0,
        category: 'Mobile',
        difficulty: 'Easy',
        tags: ['dart', 'flutter'],
        isAiGenerated: false,
        estimatedTimeSec: 45,
      );

      expect(question.questionText, 'What is Dart?');
      expect(question.category, 'Mobile');
      expect(question.difficulty, 'Easy');
      expect(question.tags, ['dart', 'flutter']);
      expect(question.estimatedTimeSec, 45);
    });

    test('GetQuestionsUseCase executes query to repository successfully', () async {
      final fakeDs = FakeQuestionsRemoteDataSource(shouldSucceed: true);
      final repository = QuestionsRepositoryImpl(fakeDs);
      final useCase = GetQuestionsUseCase(repository);

      final List<MasterQuestion> questions = await useCase();

      expect(questions.length, 1);
      final question = questions.first;
      expect(question.id, 'question-12345');
      expect(question.questionText, 'What is NestJS?');
      expect(question.options, ['Framework', 'Database', 'Library', 'OS']);
      expect(question.correctOptionIndex, 0);
      expect(question.category, 'Backend');
      expect(question.difficulty, 'Easy');
      expect(question.tags, ['nestjs', 'node']);
      expect(question.isAiGenerated, false);
      expect(question.estimatedTimeSec, 60);
    });
  });
}
