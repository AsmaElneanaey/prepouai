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

  @override
  Future<McqExamModel> fetchExamSession() async {
    final sessionsResponse = await _dio.get(ApiEndpoints.createSession);
    if (sessionsResponse.statusCode != 200) {
      throw Exception('Failed to load user interview sessions');
    }
    
    final data = sessionsResponse.data;
    if (data is! Map) {
      throw Exception('Unexpected session response format');
    }

    final sessions = data['data'] as List<dynamic>? ?? const [];
    if (sessions.isEmpty) {
      throw Exception('No interview sessions found. Please set up a pipeline first.');
    }

    final latestSession = sessions.firstWhere(
      (s) => s is Map && s['status'] == 'active',
      orElse: () => sessions.first,
    ) as Map?;

    if (latestSession == null) {
      throw Exception('Could not find active session.');
    }

    final stages = latestSession['stages'] as List?;
    if (stages == null) {
      throw Exception('No stages found in active session.');
    }

    final mcqStage = stages.firstWhere(
      (s) => s is Map && s['stage_type'] == 'mcq',
      orElse: () => throw Exception('Could not find an MCQ stage in the active session.'),
    ) as Map;

    final mcqStageId = mcqStage['_id'] as String? ?? mcqStage['id'] as String?;
    if (mcqStageId == null || mcqStageId.isEmpty) {
      throw Exception('Invalid MCQ stage ID.');
    }

    // Start the MCQ stage using the real API
    final startResponse = await startMcqStage(mcqStageId);

    return McqExamModel(
      questions: startResponse.questions,
      durationSeconds: startResponse.durationSeconds,
      stageId: mcqStageId,
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

        final error = data['error'];
        if (error is Map<String, dynamic> && error['message'] is String) {
          return error['message'] as String;
        }
      }
    }
    return e.message ?? 'An unknown error occurred';
  }
}
