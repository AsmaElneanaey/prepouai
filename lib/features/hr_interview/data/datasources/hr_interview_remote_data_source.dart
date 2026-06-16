import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/hr_interview_session_model.dart';
import '../models/hr_stage_models.dart';

abstract class HrInterviewRemoteDataSource {
  Future<HrInterviewSessionModel> fetchActiveSession();

  Future<StartHrResponseDto> startHrStage(String id, String focusArea);

  Future<HrSubmitResponseDto> submitResponse({
    required String id,
    required String responseText,
    String? audioRecordingUrl,
  });

  Future<HrNextQuestionDto> getNextQuestion(String id);
}

class HrInterviewRemoteDataSourceImpl implements HrInterviewRemoteDataSource {
  HrInterviewRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<HrInterviewSessionModel> fetchActiveSession() async {
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

      final hrStage = stages.firstWhere(
        (s) => s is Map && s['stage_type'] == 'hr_interview',
        orElse: () => throw Exception('Could not find an HR stage in the active session.'),
      ) as Map;

      final hrStageId = hrStage['_id'] as String? ?? hrStage['id'] as String?;
      if (hrStageId == null || hrStageId.isEmpty) {
        throw Exception('Invalid HR stage ID.');
      }

      final String activeQuestion;
      final String status = hrStage['status'] as String? ?? 'not_started';

      if (status != 'started' && status != 'completed') {
        // Start the HR interview stage using the real API
        final startResponse = await startHrStage(hrStageId, 'Behavioral');
        activeQuestion = startResponse.question;
      } else {
        // Retrieve the current active question
        final nextQuestionResponse = await getNextQuestion(hrStageId);
        activeQuestion = nextQuestionResponse.data.question;
      }

      return HrInterviewSessionModel(
        stageId: hrStageId,
        headerTimerLabel: '0:00',
        interviewerName: 'PrepYou AI',
        interviewerRole: 'HR Interviewer',
        liveQuestionCue: activeQuestion,
        messages: [
          {
            'sender': 'ai',
            'body': activeQuestion,
            'timestamp': '0:00',
          }
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
  Future<StartHrResponseDto> startHrStage(String id, String focusArea) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.hrInterviewStage}/$id/start',
        data: {
          'focus_area': focusArea,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StartHrResponseDto.fromJson(
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
  Future<HrSubmitResponseDto> submitResponse({
    required String id,
    required String responseText,
    String? audioRecordingUrl,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.hrInterviewStage}/$id/submit-response',
        data: {
          'response_text': responseText,
          // ignore: use_null_aware_elements
          if (audioRecordingUrl != null) 'audio_recording_url': audioRecordingUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HrSubmitResponseDto.fromJson(
          response.data as Map<String, dynamic>,
          responseText,
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
  Future<HrNextQuestionDto> getNextQuestion(String id) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.hrInterviewStage}/$id/next-question',
      );

      if (response.statusCode == 200) {
        return HrNextQuestionDto.fromJson(
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
