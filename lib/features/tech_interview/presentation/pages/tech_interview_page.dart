import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/prepyou_app_bar.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/datasources/tech_interview_remote_data_source.dart';
import '../../data/repositories/tech_interview_repository_impl.dart';
import '../../domain/usecases/get_tech_interview.dart';
import '../../domain/usecases/submit_code.dart';
import '../../domain/usecases/complete_tech_interview_stage_use_case.dart';
import '../../domain/usecases/send_tech_chat_message_use_case.dart';
import '../bloc/tech_interview_bloc.dart';
import '../bloc/tech_interview_event.dart';
import '../bloc/tech_interview_state.dart';
import '../theme/tech_interview_theme.dart';
import '../widgets/code_editor_card.dart';
import '../widgets/tech_chat_panel.dart';
import '../widgets/tech_interviewer_header.dart';
import '../widgets/tech_voice_controls_bar.dart';
import '../widgets/tech_complete_sheet.dart';

class TechInterviewPage extends StatelessWidget {
  const TechInterviewPage({super.key});

  static TechInterviewBloc _createBloc() {
    final secureStorageService = SecureStorageService();
    final dioClient = DioClient(secureStorageService);
    final ds = TechInterviewRemoteDataSourceImpl(dioClient.dio);
    final repo = TechInterviewRepositoryImpl(ds);
    return TechInterviewBloc(
      GetTechInterviewUseCase(repo),
      SubmitCodeUseCase(repo),
      CompleteTechInterviewStageUseCase(repo),
      SendTechChatMessageUseCase(repo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc()..add(const TechInterviewRequested()),
      child: const _TechInterviewView(),
    );
  }
}

class _TechInterviewView extends StatefulWidget {
  const _TechInterviewView();

  @override
  State<_TechInterviewView> createState() => _TechInterviewViewState();
}

class _TechInterviewViewState extends State<_TechInterviewView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildDifficultyChip(String diff) {
    Color bg = TechInterviewTheme.difficultyEasy.withValues(alpha: 0.1);
    Color fg = TechInterviewTheme.difficultyEasy;
    if (diff == 'medium') {
      bg = TechInterviewTheme.difficultyMedium.withValues(alpha: 0.1);
      fg = TechInterviewTheme.difficultyMedium;
    } else if (diff == 'hard') {
      bg = TechInterviewTheme.difficultyHard.withValues(alpha: 0.1);
      fg = TechInterviewTheme.difficultyHard;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        diff.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDescriptionTab(TechInterviewLoaded state) {
    final question = state.session.question;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Problem statement details
          Container(
            decoration: BoxDecoration(
              color: TechInterviewTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: TechInterviewTheme.borderMuted.withValues(alpha: 0.8)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      question.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildDifficultyChip(question.difficulty.name),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  question.description,
                  style: const TextStyle(
                    color: TechInterviewTheme.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Chat panel
          SizedBox(
            height: 320,
            child: TechChatPanel(session: state.session),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEditorTab(TechInterviewLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CodeEditorCard(
              code: state.currentCode,
              language: state.currentLanguage,
              terminalOutput: state.terminalOutput,
              isSubmitting: state.isSubmitting,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TechInterviewTheme.pageBg,
      appBar: const PrepYouAppBar(title: 'Technical Round', showBack: true),
      body: BlocConsumer<TechInterviewBloc, TechInterviewState>(
        listenWhen: (previous, current) {
          if (previous is TechInterviewLoaded && current is TechInterviewLoaded) {
            return !previous.isSuccess && current.isSuccess;
          }
          return false;
        },
        listener: (context, state) {
          if (state is TechInterviewLoaded && state.isSuccess) {
            TechCompleteSheet.show(context);
          }
        },
        builder: (context, state) {
          if (state is TechInterviewLoading || state is TechInterviewInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: TechInterviewTheme.accentGreen,
              ),
            );
          }

          if (state is TechInterviewError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: TechInterviewTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<TechInterviewBloc>()
                            .add(const TechInterviewRequested());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TechInterviewTheme.accentGreen,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TechInterviewLoaded) {
            return Column(
              children: [
                TechInterviewerHeader(session: state.session),
                
                // Stage indicator & Tab bar
                Container(
                  color: TechInterviewTheme.cardBg,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'STAGE 4 OF 5',
                          style: TextStyle(
                            color: TechInterviewTheme.accentGreen,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: TechInterviewTheme.accentGreen,
                          labelColor: Colors.white,
                          unselectedLabelColor: TechInterviewTheme.textMuted,
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: const [
                            Tab(text: 'Problem & Discussion'),
                            Tab(text: 'Code Workspace'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      TabBarView(
                        controller: _tabController,
                        children: [
                          _buildDescriptionTab(state),
                          _buildEditorTab(state),
                        ],
                      ),
                      
                      // Floating Voice Controls Bar at Bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: TechVoiceControlsBar(
                          isSuccess: state.isSuccess,
                          isSubmitting: state.isSubmitting,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
