import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/prepyou_app_bar.dart';
import '../../../../services/auth_service.dart';
import '../../data/datasources/final_report_remote_data_source.dart';
import '../../data/repositories/final_report_repository_impl.dart';
import '../../domain/usecases/get_final_report.dart';
import '../bloc/final_report_bloc.dart';
import '../bloc/final_report_event.dart';
import '../bloc/final_report_state.dart';
import '../theme/final_report_theme.dart';
import '../widgets/glass_button.dart';
import '../widgets/detailed_feedback_card.dart';
import '../widgets/score_gauge.dart';
import '../widgets/stage_scores_breakdown.dart';


class FinalReportPage extends StatelessWidget {
  const FinalReportPage({super.key});

  static FinalReportBloc _createBloc() {
    final ds = FinalReportRemoteDataSourceImpl();
    final repo = FinalReportRepositoryImpl(ds);
    return FinalReportBloc(GetFinalReportUseCase(repo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc()..add(const FinalReportRequested()),
      child: const _FinalReportView(),
    );
  }
}

class _FinalReportView extends StatelessWidget {
  const _FinalReportView();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [FinalReportTheme.pageBg, FinalReportTheme.cardBg],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
      backgroundColor: FinalReportTheme.pageBg,
      appBar: const PrepYouAppBar(title: 'Final Report', showBack: true),
      body: BlocBuilder<FinalReportBloc, FinalReportState>(
        builder: (context, state) {
          if (state is FinalReportLoading || state is FinalReportInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: FinalReportTheme.accentGreen,
              ),
            );
          }

          if (state is FinalReportError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: FinalReportTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<FinalReportBloc>()
                            .add(const FinalReportRequested());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FinalReportTheme.accentGreen,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FinalReportLoaded) {
            final report = state.report;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stage Label Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: FinalReportTheme.accentGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: FinalReportTheme.accentGreen.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Text(
                        'STAGE 5 OF 5',
                        style: TextStyle(
                          color: FinalReportTheme.accentGreen,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Candidate info card
                  BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: FinalReportTheme.glassCardDecoration,
                        child: Column(
                          children: [
                            Text(
                              report.candidateName,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              report.candidateRole,
                              style: GoogleFonts.outfit(
                                color: FinalReportTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Evaluated on ${report.pipelineDateLabel}',
                              style: GoogleFonts.outfit(
                                color: FinalReportTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Radial Gauge
                  Center(
                     child: AnimatedScale(
                       scale: 1.0,
                       duration: const Duration(milliseconds: 800),
                       child: ScoreGauge(score: report.overallScore),
                     ),
                   ),
                  const SizedBox(height: 24),

                  // Stage Breakdown
                  StageScoresBreakdown(scores: report.stageScores),
                  const SizedBox(height: 24),

                  // Strengths & Improvements Card
                  DetailedFeedbackCard(
                    strengths: report.strengths,
                    improvements: report.improvements,
                  ),
                  const SizedBox(height: 32),

                  // Finish Button
                  GlassButton(
                     text: 'Return to Dashboard',
                     onPressed: () {
                       selectedBottomNavIndex.value = 0; // go back to Home in nav bar state
                       Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                     },
                   ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    ));
  }
}
