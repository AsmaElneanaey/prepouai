import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/prepyou_app_bar.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/datasources/cv_report_remote_data_source.dart';
import '../../data/repositories/cv_report_repository_impl.dart';
import '../../domain/usecases/get_cv_report.dart';
import '../bloc/cv_report_bloc.dart';
import '../bloc/cv_report_event.dart';
import '../bloc/cv_report_state.dart';
import '../theme/cv_report_theme.dart';
import '../widgets/ai_suggestions_card.dart';
import '../widgets/continue_cta_bar.dart';
import '../widgets/cv_file_card.dart';
import '../widgets/match_score_card.dart';
import '../widgets/skills_breakdown_card.dart';
import '../widgets/stage_header.dart';
import '../widgets/work_experience_card.dart';

class CvReportPage extends StatelessWidget {
  const CvReportPage({super.key});

  static CvReportBloc _createBloc() {
    final secureStorageService = SecureStorageService();
    final dioClient = DioClient(secureStorageService);
    final dataSource = CvReportRemoteDataSourceImpl(dioClient.dio, secureStorageService);
    final repository = CvReportRepositoryImpl(dataSource);
    final useCase = GetCvReportUseCase(repository);
    return CvReportBloc(useCase);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final fileName = args?['fileName'] as String?;
    final fileSizeBytes = args?['fileSize'] as int?;
    final stageId = args?['stageId'] as String?;

    return BlocProvider(
      create: (_) => _createBloc()
        ..add(
          CvReportRequested(
            cvFileName: fileName,
            fileSizeBytes: fileSizeBytes,
            stageId: stageId,
          ),
        ),
      child: const _CvReportView(),
    );
  }
}

class _CvReportView extends StatelessWidget {
  const _CvReportView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CvReportTheme.pageBackground,
      appBar: const PrepYouAppBar(title: 'CV Report', showBack: true),
      body: BlocBuilder<CvReportBloc, CvReportState>(
        builder: (context, state) {
          if (state is CvReportLoading || state is CvReportInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: CvReportTheme.primaryGreen,
              ),
            );
          }

          if (state is CvReportError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: CvReportTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final args = ModalRoute.of(context)?.settings.arguments
                            as Map<String, dynamic>?;
                        context.read<CvReportBloc>().add(
                              CvReportRequested(
                                cvFileName: args?['fileName'] as String?,
                                fileSizeBytes: args?['fileSize'] as int?,
                                stageId: args?['stageId'] as String?,
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CvReportTheme.primaryGreen,
                        foregroundColor: CvReportTheme.pageBackground,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CvReportLoaded) {
            final report = state.report;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StageHeader(report: report),
                  const SizedBox(height: 16),
                  CvFileCard(file: report.file),
                  const SizedBox(height: 16),
                  MatchScoreCard(matchScore: report.matchScore),
                  const SizedBox(height: 16),
                  SkillsBreakdownCard(skills: report.skills),
                  const SizedBox(height: 16),
                  AiSuggestionsCard(suggestions: report.suggestions),
                  const SizedBox(height: 16),
                  WorkExperienceCard(experiences: report.experiences),
                  const SizedBox(height: 100),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContinueCtaBar(),
          AppBottomNav(currentIndex: 1),
        ],
      ),
    );
  }
}
