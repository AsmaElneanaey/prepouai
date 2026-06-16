import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../models/cv_report_model.dart';
import '../models/cv_upload_models.dart';

abstract class CvReportRemoteDataSource {
  Future<CvReportModel> fetchCvReport({
    String? cvFileName,
    int? fileSizeBytes,
    String? stageId,
  });

  Future<CvUploadResponseDto> uploadCv({
    required String stageId,
    required String filePath,
  });

  Future<CvParseResponseDto> parseCv(String id);

  Future<CvSkillsResponseDto> getCvSkills(String id);
}

class CvReportRemoteDataSourceImpl implements CvReportRemoteDataSource {
  CvReportRemoteDataSourceImpl(this._dio, this._secureStorageService);

  final Dio _dio;
  final SecureStorageService _secureStorageService;
  @override
  Future<CvReportModel> fetchCvReport({
    String? cvFileName,
    int? fileSizeBytes,
    String? stageId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final fileName = cvFileName ?? 'Alex_Johnson_CV_2026.pdf';
    final fileSizeLabel = _formatFileSize(fileSizeBytes ?? 250880);

    String? targetStageId = stageId;

    // 1. Try to find active session and stageId if not provided
    if (targetStageId == null) {
      try {
        final sessionsResponse = await _dio.get(ApiEndpoints.createSession);
        if (sessionsResponse.statusCode == 200) {
          final data = sessionsResponse.data;
          if (data is Map) {
            final sessions = data['data'];
            if (sessions is List && sessions.isNotEmpty) {
              final latestSession = sessions.firstWhere(
                (s) => s is Map && s['status'] == 'active',
                orElse: () => sessions.first,
              ) as Map?;
              
              final stages = latestSession?['stages'] as List?;
              if (stages != null) {
                final cvUploadStage = stages.firstWhere(
                  (s) => s is Map && s['stage_type'] == 'cv_upload',
                  orElse: () => null,
                );
                if (cvUploadStage is Map) {
                  targetStageId = cvUploadStage['_id'] as String? ?? cvUploadStage['id'] as String?;
                }
              }
            }
          }
        }
      } catch (_) {}
    }

    // 2. Fetch User Profile for dynamic fallbacks
    String candidateName = 'Candidate';
    try {
      final profileResponse = await _dio.get(ApiEndpoints.profile);
      if (profileResponse.statusCode == 200) {
        final data = profileResponse.data;
        if (data is Map) {
          final userData = data['data'];
          if (userData is Map) {
            final user = userData['user'];
            if (user is Map) {
              final first = user['first_name'] as String? ?? '';
              final last = user['last_name'] as String? ?? '';
              if (first.isNotEmpty || last.isNotEmpty) {
                candidateName = '$first $last'.trim();
              }
            }
          }
        }
      }
    } catch (_) {}

    // Initialize defaults
    int matchScore = 85;
    String role = 'Software Engineer';
    String experienceLabel = '2 years experience';
    int filledStars = 4;
    String matchLabel = 'Strong match';
    List<String> suggestions = [
      'Highlight relevant technical skills, programming languages, and frameworks.',
      'Detail your work experiences, emphasizing measurable impacts and outcomes.',
      'Keep formatting clean and ensure correct spelling and structure.'
    ];
    List<Map<String, dynamic>> experiences = [];
    List<Map<String, dynamic>> skillsList = [];

    // 3. Try to load parsed CV data from cache
    bool loadedFromCache = false;
    if (targetStageId != null) {
      try {
        final cachedData = await _secureStorageService.getParsedCvData(targetStageId);
        if (cachedData != null) {
          final parsedSections = jsonDecode(cachedData);
          if (parsedSections is Map) {
            candidateName = parsedSections['candidate_name'] as String? ?? candidateName;
            role = parsedSections['role'] as String? ?? role;
            
            final expYears = parsedSections['experience_years'] as int? ?? 0;
            experienceLabel = expYears > 0 ? '$expYears years experience' : 'Entry level';
            
            matchScore = parsedSections['ai_score'] as int? ?? parsedSections['match_score'] as int? ?? matchScore;
            filledStars = (matchScore / 20).round().clamp(1, 5);
            matchLabel = parsedSections['match_label'] as String? ?? (matchScore >= 80 ? 'Strong match' : 'Good match');

          final rawSuggestions = parsedSections['suggestions'] as List?;
          if (rawSuggestions != null && rawSuggestions.isNotEmpty) {
            suggestions = rawSuggestions.map((e) => e.toString()).toList();
          }

          final rawExperience = parsedSections['work_experience'] as List?;
          if (rawExperience != null && rawExperience.isNotEmpty) {
            experiences = rawExperience.map((e) {
              if (e is Map) {
                final rTitle = e['role'] as String? ?? '';
                final rCompany = e['company'] as String? ?? '';
                final start = e['start_date'] as String? ?? e['start'] as String? ?? '';
                final end = e['end_date'] as String? ?? e['end'] as String? ?? '';
                final period = start.isNotEmpty && end.isNotEmpty ? '$start – $end' : (start.isNotEmpty ? start : end);
                final desc = e['description'] as String? ?? '';
                return {
                  'title': rTitle,
                  'company': rCompany,
                  'period': period,
                  'description': desc,
                };
              }
              return <String, dynamic>{};
            }).where((e) => e.isNotEmpty).toList();
          }

          final rawSkills = parsedSections['skills'] as List?;
          if (rawSkills != null && rawSkills.isNotEmpty) {
            final colors = ['blue', 'green', 'purple', 'yellow', 'red'];
            skillsList = rawSkills.asMap().entries.map((entry) {
              final idx = entry.key;
              final s = entry.value;
              String name = '';
              int percent = 80;
              if (s is Map) {
                name = s['name'] as String? ?? '';
                percent = s['proficiency_pct'] as int? ?? 80;
              } else if (s is String) {
                name = s;
              }
              final color = colors[idx % colors.length];
              return {
                'name': name.isNotEmpty ? name : 'Skill',
                'percent': percent,
                'barColor': color,
              };
            }).toList();
          }

          loadedFromCache = true;
          }
        }
      } catch (_) {}
    }

    // 4. Fallback skills retrieval from GET /skills if not loaded from cache
    if (!loadedFromCache && targetStageId != null) {
      try {
        final skillsResponse = await _dio.get('${ApiEndpoints.cvUploadStage}/$targetStageId/skills');
        if (skillsResponse.statusCode == 200) {
          final skillsData = skillsResponse.data;
          if (skillsData is Map && skillsData['data'] is List) {
            final rawSkillsList = skillsData['data'] as List;
            if (rawSkillsList.isNotEmpty) {
              final colors = ['blue', 'green', 'purple', 'yellow', 'red'];
              skillsList = rawSkillsList.asMap().entries.map((entry) {
                final idx = entry.key;
                final val = entry.value;
                String name = '';
                int percent = 95 - (idx * 7).clamp(0, 45);
                if (val is String) {
                  name = val;
                } else if (val is Map) {
                  final skillIdMap = val['skill_id'];
                  name = skillIdMap is Map ? (skillIdMap['name'] as String? ?? '') : (val['name'] as String? ?? '');
                  percent = val['proficiency_pct'] as int? ?? percent;
                }
                final color = colors[idx % colors.length];
                return {
                  'name': name.isNotEmpty ? name : 'Skill',
                  'percent': percent,
                  'barColor': color,
                };
              }).toList();
            }
          }
        }
      } catch (_) {}
    }

    // Double fallback for skills if both cache and API returned empty
    if (skillsList.isEmpty) {
      skillsList = [
        {'name': 'React / Next.js', 'percent': 92, 'barColor': 'blue'},
        {'name': 'TypeScript', 'percent': 88, 'barColor': 'green'},
        {'name': 'Node.js', 'percent': 75, 'barColor': 'purple'},
        {'name': 'System Design', 'percent': 63, 'barColor': 'yellow'},
        {'name': 'DSA', 'percent': 58, 'barColor': 'red'},
      ];
    }

    // Double fallback for experiences if empty
    if (experiences.isEmpty) {
      experiences = [
        {
          'title': 'Software Engineer',
          'company': 'Innovate Tech',
          'period': '2023 – Present',
          'description': 'Developed modern frontend interfaces and integrated REST APIs.',
        },
      ];
    }

    return CvReportModel(
      stageLabel: 'Stage 1 of 5',
      title: 'CV Report',
      subtitle: 'AI will analyze your resume and match it to your target role.',
      fileName: fileName,
      fileSizeLabel: fileSizeLabel,
      isParsed: true,
      matchScore: matchScore,
      candidateName: candidateName,
      role: role,
      experienceLabel: experienceLabel,
      filledStars: filledStars,
      matchLabel: matchLabel,
      skills: skillsList,
      suggestions: suggestions,
      experiences: experiences,
    );
  }

  @override
  Future<CvUploadResponseDto> uploadCv({
    required String stageId,
    required String filePath,
  }) async {
    try {
      final fileName = filePath.split('/').last.split(r'\').last;
      final formData = FormData.fromMap({
        'stage_id': stageId,
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _dio.post(
        ApiEndpoints.cvUpload,
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final mapData = data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
        return CvUploadResponseDto.fromJson(mapData);
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
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseBody = response.data;
        if (responseBody is String) {
          try {
            responseBody = jsonDecode(responseBody);
          } catch (_) {}
        }
        if (responseBody is Map) {
          final rawData = responseBody['data'];
          if (rawData is Map) {
            final parsedCv = rawData['parsedCv'];
            if (parsedCv is Map) {
              final parsedSections = parsedCv['parsed_sections'];
              if (parsedSections is Map) {
                await _secureStorageService.saveParsedCvData(id, jsonEncode(parsedSections));
              }
            }
          }
        }
        final mapData = responseBody is Map ? Map<String, dynamic>.from(responseBody) : <String, dynamic>{};
        return CvParseResponseDto.fromJson(mapData);
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
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'AI parsing timed out. Please try again.';
    }
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
