import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/cv_report/data/datasources/cv_report_remote_data_source.dart';
import 'package:prepouai/features/cv_report/data/models/cv_report_model.dart';
import 'package:prepouai/features/cv_report/data/models/cv_upload_models.dart';
import 'package:prepouai/features/cv_report/data/repositories/cv_report_repository_impl.dart';
import 'package:prepouai/features/cv_report/domain/entities/cv_upload_response.dart';
import 'package:prepouai/features/cv_report/domain/entities/cv_parse_response.dart';
import 'package:prepouai/features/skills/domain/entities/skill.dart';
import 'package:prepouai/features/cv_report/domain/usecases/upload_cv_use_case.dart';
import 'package:prepouai/features/cv_report/domain/usecases/parse_cv_use_case.dart';
import 'package:prepouai/features/cv_report/domain/usecases/get_cv_skills_use_case.dart';

class FakeCvReportRemoteDataSource implements CvReportRemoteDataSource {
  FakeCvReportRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<CvReportModel> fetchCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return CvReportModel(
      stageLabel: 'Stage 1 of 5',
      title: 'CV Report',
      subtitle: 'AI analysis',
      fileName: cvFileName ?? 'Alex_Johnson_CV_2026.pdf',
      fileSizeLabel: '245 KB',
      isParsed: true,
      matchScore: 91,
      candidateName: 'Alex Johnson',
      role: 'Senior Frontend Engineer',
      experienceLabel: '5 years experience',
      filledStars: 4,
      matchLabel: 'Strong match',
      skills: const [
        {'name': 'React', 'percent': 92, 'barColor': 'blue'},
        {'name': 'TypeScript', 'percent': 88, 'barColor': 'green'},
        {'name': 'Node.js', 'percent': 75, 'barColor': 'purple'},
        {'name': 'System Design', 'percent': 63, 'barColor': 'yellow'},
        {'name': 'DSA', 'percent': 58, 'barColor': 'red'},
      ],
      suggestions: const ['Suggestion 1'],
      experiences: const [
        {
          'title': 'Senior Frontend Engineer',
          'company': 'Stripe',
          'period': '2022 – Present',
          'description': 'Led UI architecture.',
        },
        {
          'title': 'Software Engineer',
          'company': 'Zalando',
          'period': '2019 – 2022',
          'description': 'Built React micro-frontends.',
        },
      ],
    );
  }

  @override
  Future<CvUploadResponseDto> uploadCv(String filePath) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return CvUploadResponseDto.fromJson({
      'success': true,
      'message': 'CV uploaded successfully',
      'data': {
        '_id': 'cv-id-12345',
        'fileName': 'resume.pdf',
        'fileSize': 204800,
        'status': 'uploaded'
      }
    });
  }

  @override
  Future<CvParseResponseDto> parseCv(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return CvParseResponseDto.fromJson({
      'success': true,
      'message': 'CV parsed successfully',
      'data': {
        '_id': id,
        'isParsed': true,
        'status': 'parsed'
      }
    });
  }

  @override
  Future<CvSkillsResponseDto> getCvSkills(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return CvSkillsResponseDto.fromJson({
      'success': true,
      'message': 'Skills fetched successfully',
      'data': [
        {
          '_id': 'skill-123',
          'name': 'NestJS',
          'category': 'Backend',
          'description': 'A progressive Node.js framework.'
        }
      ]
    });
  }
}

void main() {
  group('CV Report Clean Architecture Test Suite', () {
    test('getCvReport returns entity with match score 91', () async {
      final fakeDs = FakeCvReportRemoteDataSource(shouldSucceed: true);
      final repository = CvReportRepositoryImpl(fakeDs);
      final report = await repository.getCvReport();

      expect(report.matchScore.score, 91);
      expect(report.skills, hasLength(5));
      expect(report.experiences, hasLength(2));
    });

    test('getCvReport uses provided file name', () async {
      final fakeDs = FakeCvReportRemoteDataSource(shouldSucceed: true);
      final repository = CvReportRepositoryImpl(fakeDs);
      final report = await repository.getCvReport(
        cvFileName: 'custom_cv.pdf',
      );

      expect(report.file.fileName, 'custom_cv.pdf');
    });

    test('uploadCv returns valid CvUploadResponse entity', () async {
      final fakeDs = FakeCvReportRemoteDataSource(shouldSucceed: true);
      final repository = CvReportRepositoryImpl(fakeDs);
      final useCase = UploadCvUseCase(repository);

      final CvUploadResponse response = await useCase('path/to/resume.pdf');

      expect(response.id, 'cv-id-12345');
      expect(response.fileName, 'resume.pdf');
      expect(response.fileSize, 204800);
      expect(response.status, 'uploaded');
    });

    test('parseCv returns valid CvParseResponse entity', () async {
      final fakeDs = FakeCvReportRemoteDataSource(shouldSucceed: true);
      final repository = CvReportRepositoryImpl(fakeDs);
      final useCase = ParseCvUseCase(repository);

      final CvParseResponse response = await useCase('cv-id-12345');

      expect(response.id, 'cv-id-12345');
      expect(response.isParsed, true);
      expect(response.status, 'parsed');
    });

    test('getCvSkills returns list of skills correctly mapped', () async {
      final fakeDs = FakeCvReportRemoteDataSource(shouldSucceed: true);
      final repository = CvReportRepositoryImpl(fakeDs);
      final useCase = GetCvSkillsUseCase(repository);

      final List<Skill> skills = await useCase('cv-id-12345');

      expect(skills, hasLength(1));
      expect(skills.first.id, 'skill-123');
      expect(skills.first.name, 'NestJS');
      expect(skills.first.category, 'Backend');
      expect(skills.first.description, 'A progressive Node.js framework.');
    });
  });
}
