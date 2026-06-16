import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/mcq_exam_model.dart';
import '../models/mcq_stage_models.dart';

abstract class McqExamRemoteDataSource {
  Future<McqExamModel> fetchExamSession();

  Future<StartMcqResponseDto> startMcqStage(String id);

  Future<McqAnswerResponseDto> submitAnswer({
    required String id,
    required String questionId,
    required int selectedOptionIndex,
    required int timeSpentSeconds,
  });

  Future<McqCompleteResponseDto> completeMcqStage(String id);
}

class McqExamRemoteDataSourceImpl implements McqExamRemoteDataSource {
  McqExamRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const _sampleQuestions = [
    {
      'category': 'React',
      'difficulty': 'medium',
      'text':
          'Which hook should you use when you need to synchronize a React component with an external system?',
      'options': [
        {'id': 'A', 'label': 'useState'},
        {'id': 'B', 'label': 'useEffect'},
        {'id': 'C', 'label': 'useRef'},
        {'id': 'D', 'label': 'useMemo'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'useEffect runs side effects after render and is the standard hook for syncing with external systems.',
    },
    {
      'category': 'TypeScript',
      'difficulty': 'medium',
      'text':
          'What is the primary purpose of the `readonly` modifier in TypeScript?',
      'options': [
        {'id': 'A', 'label': 'Prevent reassignment of properties'},
        {'id': 'B', 'label': 'Make variables private'},
        {'id': 'C', 'label': 'Enable runtime type checks'},
        {'id': 'D', 'label': 'Convert types to interfaces'},
      ],
      'correctOptionId': 'A',
      'explanation':
          'readonly prevents reassignment of properties on objects and interfaces at compile time.',
    },
    {
      'category': 'Algorithms',
      'difficulty': 'medium',
      'text': 'What is the average time complexity of binary search?',
      'options': [
        {'id': 'A', 'label': 'O(n)'},
        {'id': 'B', 'label': 'O(log n)'},
        {'id': 'C', 'label': 'O(n log n)'},
        {'id': 'D', 'label': 'O(1)'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Binary search halves the search space each step, giving O(log n) average time.',
    },
    {
      'category': 'System Design',
      'difficulty': 'hard',
      'text': 'What does horizontal scaling primarily improve?',
      'options': [
        {'id': 'A', 'label': 'Single-machine CPU clock speed'},
        {'id': 'B', 'label': 'Capacity by adding more machines'},
        {'id': 'C', 'label': 'Database index size'},
        {'id': 'D', 'label': 'Client bundle size'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Horizontal scaling adds more nodes to distribute load and increase throughput.',
    },
    {
      'category': 'JavaScript',
      'difficulty': 'easy',
      'text':
          'What does the `Promise.all()` method do when one of the promises rejects?',
      'options': [
        {'id': 'A', 'label': 'It waits for all promises to settle'},
        {'id': 'B', 'label': 'It immediately rejects with that reason'},
        {'id': 'C', 'label': 'It ignores the rejection'},
        {'id': 'D', 'label': 'It returns undefined for that promise'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Promise.all() fails fast — if any promise rejects, the entire Promise.all() rejects immediately.',
    },
    {
      'category': 'Node.js',
      'difficulty': 'easy',
      'text': 'Which module system is natively supported in modern Node.js?',
      'options': [
        {'id': 'A', 'label': 'AMD'},
        {'id': 'B', 'label': 'CommonJS and ESM'},
        {'id': 'C', 'label': 'UMD only'},
        {'id': 'D', 'label': 'SystemJS'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Node.js supports both CommonJS (require) and ECMAScript modules (import).',
    },
  ];

  @override
  Future<McqExamModel> fetchExamSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final questions = List<Map<String, dynamic>>.generate(5, (i) {
      final sample = _sampleQuestions[i % _sampleQuestions.length];
      return Map<String, dynamic>.from(sample);
    });

    return McqExamModel(
      questions: questions,
      durationSeconds: 20 * 60,
    );
  }

  @override
  Future<StartMcqResponseDto> startMcqStage(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.mcqStage}/$id/start',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StartMcqResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<McqAnswerResponseDto> submitAnswer({
    required String id,
    required String questionId,
    required int selectedOptionIndex,
    required int timeSpentSeconds,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.mcqStage}/$id/answer',
        data: {
          'question_id': questionId,
          'selected_option_index': selectedOptionIndex,
          'time_spent_seconds': timeSpentSeconds,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return McqAnswerResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<McqCompleteResponseDto> completeMcqStage(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.mcqStage}/$id/complete',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return McqCompleteResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _parseErrorMessage(DioException e) {
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is List) {
          return message.join(', ');
        } else if (message is String) {
          return message;
        }
      }
    }
    return e.message ?? 'An unknown error occurred';
  }
}
