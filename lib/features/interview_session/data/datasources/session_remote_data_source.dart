import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<CreateSessionResponseDto> createSession({
    required String targetRole,
    required String seniorityLevel,
    required String targetCompanyId,
  });

  Future<GetSessionsResponseDto> getUserSessions();

  Future<GetSessionDetailsResponseDto> getSessionDetails(String sessionId);

  Future<GetCurrentStageResponseDto> getCurrentStage(String sessionId);

  Future<GetPipelineStagesResponseDto> getPipelineStages(String sessionId);

  Future<UpdateStageStatusResponseDto> updateStageStatus({
    required String stageId,
    required String status,
    int? score,
    String? badge,
  });
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  SessionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CreateSessionResponseDto> createSession({
    required String targetRole,
    required String seniorityLevel,
    required String targetCompanyId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createSession,
        data: {
          'target_role': targetRole,
          'seniority_level': seniorityLevel,
          'target_company_id': targetCompanyId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateSessionResponseDto.fromJson(
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
  Future<GetSessionsResponseDto> getUserSessions() async {
    try {
      final response = await _dio.get(ApiEndpoints.createSession);

      if (response.statusCode == 200) {
        return GetSessionsResponseDto.fromJson(
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
  Future<GetSessionDetailsResponseDto> getSessionDetails(String sessionId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.createSession}/$sessionId');

      if (response.statusCode == 200) {
        return GetSessionDetailsResponseDto.fromJson(
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
  Future<GetCurrentStageResponseDto> getCurrentStage(String sessionId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.createSession}/$sessionId/current-stage');

      if (response.statusCode == 200) {
        return GetCurrentStageResponseDto.fromJson(
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
  Future<GetPipelineStagesResponseDto> getPipelineStages(String sessionId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.pipelineStages}/$sessionId');

      if (response.statusCode == 200) {
        return GetPipelineStagesResponseDto.fromJson(
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
  Future<UpdateStageStatusResponseDto> updateStageStatus({
    required String stageId,
    required String status,
    int? score,
    String? badge,
  }) async {
    try {
      final response = await _dio.patch(
        '${ApiEndpoints.updateStageStatus}/$stageId/status',
        data: {
          'status': status,
          // ignore: use_null_aware_elements
          if (score != null) 'score': score,
          // ignore: use_null_aware_elements
          if (badge != null) 'badge': badge,
        },
      );

      if (response.statusCode == 200) {
        return UpdateStageStatusResponseDto.fromJson(
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
