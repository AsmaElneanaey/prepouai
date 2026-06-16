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
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return HrInterviewSessionModel(
      headerTimerLabel: '0:02',
      interviewerName: 'PrepYou AI',
      interviewerRole: 'HR Interviewer',
      liveQuestionCue: '"Tell me about yourself."',
      messages: const [
        {
          'sender': 'ai',
          'body':
              "Hello! I'm your PrepYou AI HR Interviewer. Let's start with a classic — tell me about yourself and your background.",
          'timestamp': '0:00',
        },
        {
          'sender': 'user',
          'body':
              "Hi! I'm a Senior Frontend Engineer with 5 years of experience building scalable web applications...",
          'timestamp': '0:32',
        },
        {
          'sender': 'ai',
          'body':
              'Great background! Can you walk me through a challenging project you led and what the outcome was?',
          'timestamp': '1:05',
        },
      ],
    );
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
      }
    }
    return e.message ?? 'An unknown error occurred';
  }
}
