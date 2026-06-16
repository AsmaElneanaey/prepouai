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
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return FinalReportModel(
      overallScore: 86,
      candidateName: 'Alex Johnson',
      candidateRole: 'Senior Frontend Engineer',
      pipelineDateLabel: 'June 9, 2026',
      stageScores: const [
        {
          'stageName': 'CV Screening',
          'score': 91,
          'feedback': 'Excellent alignment in React and TypeScript. Highlight more system metrics.',
          'iconKey': 'cv',
        },
        {
          'stageName': 'MCQ Exam',
          'score': 85,
          'feedback': 'Solid logic skills. 17 out of 20 answered correctly. Keep practicing DSA fundamentals.',
          'iconKey': 'mcq',
        },
        {
          'stageName': 'HR Behavioral',
          'score': 82,
          'feedback': 'Strong communication and Stripe background match. Good story framework.',
          'iconKey': 'hr',
        },
        {
          'stageName': 'Technical Coding',
          'score': 88,
          'feedback': 'Solved twoSum optimally with Hash Map. Clean indentation and naming.',
          'iconKey': 'tech',
        },
      ],
      strengths: const [
        'Robust expertise in Frontend and Mobile framework architectures.',
        'Optimal time-complexity approaches for live algorithm challenges.',
        'High communication rating and structured delivery of behavioral answers.',
      ],
      improvements: const [
        'Expand resume detail on Stripe backend integrations or system scaling.',
        'Deepen understanding of edge constraints (e.g. integer overflow) in live coding.',
        'Improve confidence in answering design pattern architectural tradeoffs.',
      ],
    );
  }

  @override
  Future<FinalReportResponseDto> fetchFinalReportById(String id) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.finalReportStage}/$id/report',
      );

      if (response.statusCode == 200) {
        return FinalReportResponseDto.fromJson(
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
        return FinalReportResponseDto.fromJson(
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
