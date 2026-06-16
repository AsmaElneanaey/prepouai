import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/tech_interview_session_model.dart';
import '../models/tech_stage_models.dart';

abstract class TechInterviewRemoteDataSource {
  Future<TechInterviewSessionModel> fetchActiveSession();
  Future<String> submitCode({
    required String techInterviewId,
    required String problemId,
    required String code,
    required String language,
  });
  Future<StartTechResponseDto> startTechStage(String id);
  Future<CompleteTechResponseDto> completeTechStage(String id);
  Future<String> sendChatMessage({required String id, required String message});
}

class TechInterviewRemoteDataSourceImpl implements TechInterviewRemoteDataSource {
  TechInterviewRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<TechInterviewSessionModel> fetchActiveSession() async {
    try {
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

      final techStage = stages.firstWhere(
        (s) => s is Map && s['stage_type'] == 'tech_interview',
        orElse: () => throw Exception('Could not find a Tech stage in the active session.'),
      ) as Map;

      final techStageId = techStage['_id'] as String? ?? techStage['id'] as String?;
      if (techStageId == null || techStageId.isEmpty) {
        throw Exception('Invalid Tech stage ID.');
      }

      // Start/Retrieve the Technical interview stage problem
      final startDto = await startTechStage(techStageId);

      return TechInterviewSessionModel(
        stageId: techStageId,
        questionId: startDto.problemId,
        headerTimerLabel: '0:15',
        interviewerName: 'PrepYou AI Code Coach',
        interviewerRole: 'Technical Interviewer',
        questionTitle: startDto.problemTitle,
        questionDescription: startDto.problemDescription,
        questionDifficulty: startDto.problemDifficulty,
        questionStarterCode: startDto.problemStarterCode,
        questionLanguage: startDto.problemLanguage,
        messages: [
          {
            'sender': 'ai',
            'body':
                "Welcome to the technical round. Let's solve the '${startDto.problemTitle}' problem today. You can write your solution in the workspace. Let me know if you have any questions before starting.",
            'timestamp': '0:00',
          },
        ],
      );
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> submitCode({
    required String techInterviewId,
    required String problemId,
    required String code,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.codingSubmissions,
        data: {
          'tech_interview_id': techInterviewId,
          'problem_id': problemId,
          'language': language,
          'code_submitted': code,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final innerData = data['data'] as Map<String, dynamic>? ?? const {};
        final isPassed = innerData['is_passed'] as bool? ?? false;
        final testCasesPassed = innerData['test_cases_passed'] as int? ?? 0;
        final testCasesTotal = innerData['test_cases_total'] as int? ?? 0;
        final executionTimeMs = innerData['execution_time_ms'] as int? ?? 0;

        final aiFeedbackStr = innerData['ai_feedback'] as String? ?? '';

        var qualityScore = 0;
        var feedback = '';
        var timeComplexity = '';
        var spaceComplexity = '';

        if (aiFeedbackStr.isNotEmpty) {
          try {
            final parsedFeedback = jsonDecode(aiFeedbackStr) as Map<String, dynamic>;
            qualityScore = parsedFeedback['quality_score'] as int? ?? 0;
            feedback = parsedFeedback['feedback'] as String? ?? '';
            timeComplexity = parsedFeedback['time_complexity'] as String? ?? '';
            spaceComplexity = parsedFeedback['space_complexity'] as String? ?? '';
          } catch (_) {}
        }

        final String passStatusIndicator = isPassed ? '✓' : '✗';
        final String emojiIndicator = isPassed ? 'All tests passed! 🎉' : '1 or more test cases failed. Please refine your solution.';

        return '''
[Running] sandboxed execution
$passStatusIndicator Test Cases: $testCasesPassed / $testCasesTotal passed.
- Execution time: ${executionTimeMs}ms
${isPassed ? '\nAll tests passed! 🎉\n- Code Quality Score: $qualityScore/100\n- Time Complexity: $timeComplexity\n- Space Complexity: $spaceComplexity\n- Feedback: $feedback' : '\n$emojiIndicator\n- Feedback: $feedback'}
''';
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
  Future<StartTechResponseDto> startTechStage(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.techInterviewStage}/$id/start',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StartTechResponseDto.fromJson(
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
  Future<CompleteTechResponseDto> completeTechStage(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.techInterviewStage}/$id/complete',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CompleteTechResponseDto.fromJson(
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
  Future<String> sendChatMessage({required String id, required String message}) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.techInterviewStage}/$id/chat',
        data: {
          'message': message,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final innerData = data['data'] as Map<String, dynamic>? ?? const {};
        return innerData['response'] as String? ?? '';
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
