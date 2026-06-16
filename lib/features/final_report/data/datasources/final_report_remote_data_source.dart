import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/final_report_model.dart';
import '../models/final_report_stage_models.dart';

abstract class FinalReportRemoteDataSource {
  Future<FinalReportModel> fetchFinalReport();
  Future<FinalReportResponseDto> fetchFinalReportById(String id);
  Future<ReportShareResponseDto> shareReport(String id);
  Future<FinalReportResponseDto> fetchSharedReport(String token);
}

class FinalReportRemoteDataSourceImpl implements FinalReportRemoteDataSource {
  FinalReportRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<FinalReportModel> fetchFinalReport() async {
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

      final reportStage = stages.firstWhere(
        (s) => s is Map && s['stage_type'] == 'final_report',
        orElse: () => throw Exception('Could not find a Final Report stage in the active session.'),
      ) as Map;

      final reportStageId = reportStage['_id'] as String? ?? reportStage['id'] as String?;
      if (reportStageId == null || reportStageId.isEmpty) {
        throw Exception('Invalid Final Report stage ID.');
      }

      final responseDto = await fetchFinalReportById(reportStageId);
      return responseDto.data;
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<FinalReportResponseDto> fetchFinalReportById(String id) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.finalReportStage}/$id/report',
      );

      if (response.statusCode == 200) {
        final rawData = response.data as Map<String, dynamic>;
        final innerData = rawData['data'] as Map<String, dynamic>? ?? {};
        final reportMap = innerData['report'] as Map<String, dynamic>? ?? {};
        final sessionId = reportMap['session_id'] as String? ?? '';

        Map<String, dynamic>? sessionMap;
        if (sessionId.isNotEmpty) {
          try {
            final sessionResponse = await _dio.get('${ApiEndpoints.createSession}/$sessionId');
            if (sessionResponse.statusCode == 200) {
              final sData = sessionResponse.data as Map<String, dynamic>?;
              sessionMap = sData?['data'] as Map<String, dynamic>?;
            }
          } catch (_) {}
        }

        return FinalReportResponseDto.fromApiJson(
          rawData,
          sessionMap,
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
  Future<ReportShareResponseDto> shareReport(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.finalReportStage}/$id/share',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReportShareResponseDto.fromJson(
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
  Future<FinalReportResponseDto> fetchSharedReport(String token) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.finalReportStage}/public/share/$token',
      );

      if (response.statusCode == 200) {
        final rawData = response.data as Map<String, dynamic>;
        final innerData = rawData['data'] as Map<String, dynamic>? ?? {};
        final reportMap = innerData['report'] as Map<String, dynamic>? ?? {};
        final sessionId = reportMap['session_id'] as String? ?? '';

        Map<String, dynamic>? sessionMap;
        if (sessionId.isNotEmpty) {
          try {
            final sessionResponse = await _dio.get('${ApiEndpoints.createSession}/$sessionId');
            if (sessionResponse.statusCode == 200) {
              final sData = sessionResponse.data as Map<String, dynamic>?;
              sessionMap = sData?['data'] as Map<String, dynamic>?;
            }
          } catch (_) {}
        }

        return FinalReportResponseDto.fromApiJson(
          rawData,
          sessionMap,
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
