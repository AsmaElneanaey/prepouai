import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/cv_report_model.dart';
import '../models/cv_upload_models.dart';

abstract class CvReportRemoteDataSource {
  Future<CvReportModel> fetchCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  });

  Future<CvUploadResponseDto> uploadCv(String filePath);

  Future<CvParseResponseDto> parseCv(String id);

  Future<CvSkillsResponseDto> getCvSkills(String id);
}

class CvReportRemoteDataSourceImpl implements CvReportRemoteDataSource {
  CvReportRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CvReportModel> fetchCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final fileName = cvFileName ?? 'Alex_Johnson_CV_2026.pdf';
    final fileSizeLabel = _formatFileSize(fileSizeBytes ?? 250880);

    return CvReportModel(
      stageLabel: 'Stage 1 of 5',
      title: 'CV Report',
      subtitle: 'AI will analyze your resume and match it to your target role.',
      fileName: fileName,
      fileSizeLabel: fileSizeLabel,
      isParsed: true,
      matchScore: 91,
      candidateName: 'Alex Johnson',
      role: 'Senior Frontend Engineer',
      experienceLabel: '5 years experience',
      filledStars: 4,
      matchLabel: 'Strong match',
      skills: [
        {'name': 'React / Next.js', 'percent': 92, 'barColor': 'blue'},
        {'name': 'TypeScript', 'percent': 88, 'barColor': 'green'},
        {'name': 'Node.js', 'percent': 75, 'barColor': 'purple'},
        {'name': 'System Design', 'percent': 63, 'barColor': 'yellow'},
        {'name': 'DSA', 'percent': 58, 'barColor': 'red'},
      ],
      suggestions: [
        'Add more detail to your system design experience — mention scale metrics.',
        'Include DSA achievements or competitive programming scores if applicable.',
      ],
      experiences: [
        {
          'title': 'Senior Frontend Engineer',
          'company': 'Stripe',
          'period': '2022 – Present',
          'description': 'Led UI architecture for payment dashboard.',
        },
        {
          'title': 'Software Engineer',
          'company': 'Zalando',
          'period': '2019 – 2022',
          'description': 'Built React micro-frontends for e-commerce platform.',
        },
      ],
    );
  }

  @override
  Future<CvUploadResponseDto> uploadCv(String filePath) async {
    try {
      final fileName = filePath.split('/').last.split(r'\').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _dio.post(
        ApiEndpoints.cvUpload,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CvUploadResponseDto.fromJson(
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
  Future<CvParseResponseDto> parseCv(String id) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.cvUploadStage}/$id/parse',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CvParseResponseDto.fromJson(
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
  Future<CvSkillsResponseDto> getCvSkills(String id) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.cvUploadStage}/$id/skills',
      );

      if (response.statusCode == 200) {
        return CvSkillsResponseDto.fromJson(
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).round()} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
