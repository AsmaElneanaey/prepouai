import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/final_report/data/datasources/final_report_remote_data_source.dart';
import 'package:prepouai/features/final_report/data/models/final_report_model.dart';
import 'package:prepouai/features/final_report/data/models/final_report_stage_models.dart';
import 'package:prepouai/features/final_report/data/repositories/final_report_repository_impl.dart';
import 'package:prepouai/features/final_report/domain/entities/final_report.dart';
import 'package:prepouai/features/final_report/domain/entities/report_share_response.dart';
import 'package:prepouai/features/final_report/domain/usecases/get_final_report.dart';
import 'package:prepouai/features/final_report/domain/usecases/share_report_use_case.dart';
import 'package:prepouai/features/final_report/domain/usecases/get_shared_report_use_case.dart';

class FakeFinalReportRemoteDataSource implements FinalReportRemoteDataSource {
  FakeFinalReportRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<FinalReportModel> fetchFinalReport() async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return FinalReportModel(
      overallScore: 86,
      candidateName: 'Alex Johnson',
      candidateRole: 'Senior Frontend Engineer',
      pipelineDateLabel: 'June 9, 2026',
      stageScores: const [
        {
          'stageName': 'CV Screening',
          'score': 91,
          'feedback': 'Good.',
          'iconKey': 'cv',
        }
      ],
      strengths: const ['React expert'],
      improvements: const ['Edge cases'],
    );
  }

  @override
  Future<FinalReportResponseDto> fetchFinalReportById(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return FinalReportResponseDto.fromJson({
      'success': true,
      'message': 'Report fetched',
      'data': {
        'overallScore': 90,
        'candidateName': 'Alex Johnson',
        'candidateRole': 'Senior Frontend Engineer',
        'pipelineDateLabel': 'June 9, 2026',
        'stageScores': [
          {
            'stageName': 'CV Screening',
            'score': 95,
            'feedback': 'Excellent.',
            'iconKey': 'cv',
          }
        ],
        'strengths': ['React expert'],
        'improvements': ['Edge cases'],
      }
    });
  }

  @override
  Future<ReportShareResponseDto> shareReport(String id) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return ReportShareResponseDto.fromJson(const {
      'success': true,
      'message': 'Report share link generated',
      'data': {
        'token': 'share-token-xyz',
      }
    });
  }

  @override
  Future<FinalReportResponseDto> fetchSharedReport(String token) async {
    if (!shouldSucceed) {
      throw Exception('Server error');
    }
    return FinalReportResponseDto.fromJson({
      'success': true,
      'message': 'Shared report retrieved',
      'data': {
        'overallScore': 90,
        'candidateName': 'Alex Johnson',
        'candidateRole': 'Senior Frontend Engineer',
        'pipelineDateLabel': 'June 9, 2026',
        'stageScores': [
          {
            'stageName': 'CV Screening',
            'score': 95,
            'feedback': 'Excellent.',
            'iconKey': 'cv',
          }
        ],
        'strengths': ['React expert'],
        'improvements': ['Edge cases'],
      }
    });
  }
}

void main() {
  group('Final Report Clean Architecture Test Suite', () {
    test('getFinalReport with active fallback returns mock scorecard analysis details', () async {
      final fakeDs = FakeFinalReportRemoteDataSource(shouldSucceed: true);
      final repository = FinalReportRepositoryImpl(fakeDs);
      final report = await repository.getFinalReport('active');

      expect(report.candidateName, 'Alex Johnson');
      expect(report.overallScore, 86);
      expect(report.stageScores.length, 1);
      expect(report.strengths.isNotEmpty, true);
      expect(report.improvements.isNotEmpty, true);
    });

    test('getFinalReport with specific ID returns mapped FinalReport entity', () async {
      final fakeDs = FakeFinalReportRemoteDataSource(shouldSucceed: true);
      final repository = FinalReportRepositoryImpl(fakeDs);
      final useCase = GetFinalReportUseCase(repository);

      final FinalReport report = await useCase('report-123');

      expect(report.candidateName, 'Alex Johnson');
      expect(report.overallScore, 90);
      expect(report.stageScores.first.score, 95);
    });

    test('shareReport returns valid share response entity', () async {
      final fakeDs = FakeFinalReportRemoteDataSource(shouldSucceed: true);
      final repository = FinalReportRepositoryImpl(fakeDs);
      final useCase = ShareReportUseCase(repository);

      final ReportShareResponse result = await useCase('report-123');

      expect(result.token, 'share-token-xyz');
    });

    test('getSharedReport returns valid FinalReport entity using token', () async {
      final fakeDs = FakeFinalReportRemoteDataSource(shouldSucceed: true);
      final repository = FinalReportRepositoryImpl(fakeDs);
      final useCase = GetSharedReportUseCase(repository);

      final FinalReport report = await useCase('share-token-xyz');

      expect(report.candidateName, 'Alex Johnson');
      expect(report.overallScore, 90);
      expect(report.stageScores.first.score, 95);
    });
  });
}
