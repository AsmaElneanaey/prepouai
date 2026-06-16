import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/question_model.dart';

abstract class QuestionsRemoteDataSource {
  Future<CreateQuestionResponseDto> createQuestion({
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
    required String category,
    required String difficulty,
    required List<String> tags,
    required bool isAiGenerated,
    required int estimatedTimeSec,
  });

  Future<GetQuestionsResponseDto> getQuestions();
}

class QuestionsRemoteDataSourceImpl implements QuestionsRemoteDataSource {
  QuestionsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

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
    try {
      final response = await _dio.post(
        ApiEndpoints.questions,
        data: {
          'question_text': questionText,
          'options': options,
          'correct_option_index': correctOptionIndex,
          'category': category,
          'difficulty': difficulty,
          'tags': tags,
          'is_ai_generated': isAiGenerated,
          'estimated_time_sec': estimatedTimeSec,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateQuestionResponseDto.fromJson(
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
  Future<GetQuestionsResponseDto> getQuestions() async {
    try {
      final response = await _dio.get(ApiEndpoints.questions);

      if (response.statusCode == 200) {
        return GetQuestionsResponseDto.fromJson(
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
