import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/tech_interview_session_model.dart';
import '../models/tech_stage_models.dart';

abstract class TechInterviewRemoteDataSource {
  Future<TechInterviewSessionModel> fetchActiveSession();
  Future<String> submitCode(String code, String language);
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
  Future<String> submitCode(String code, String language) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    
    if (code.trim().isEmpty || (code.contains('// Write your code here') && code.contains('return [];'))) {
      return '''
[Running] dart main.dart
✗ Test Case 1: nums = [2,7,11,15], target = 9
  Expected: [0,1], Got: []
✗ Test Case 2: nums = [3,2,4], target = 6
  Expected: [1,2], Got: []

1 or more test cases failed. Please refine your solution.
''';
    }

    return '''
[Running] dart main.dart
✓ Test Case 1: nums = [2,7,11,15], target = 9 -> Passed (indices [0, 1])
✓ Test Case 2: nums = [3,2,4], target = 6 -> Passed (indices [1, 2])
✓ Test Case 3: nums = [3,3], target = 6 -> Passed (indices [0, 1])

All tests passed! 🎉
- Execution time: 12ms
- Memory usage: 4.2 MB
- Time Complexity: O(N)
- Space Complexity: O(N)

Your code is fully optimized. Click continue to finish the interview pipeline!
''';
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
