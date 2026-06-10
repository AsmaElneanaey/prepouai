import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/prepyou_app_bar.dart';
import '../../data/datasources/hr_interview_remote_data_source.dart';
import '../../data/repositories/hr_interview_repository_impl.dart';
import '../../domain/usecases/get_hr_interview.dart';
import '../bloc/hr_interview_bloc.dart';
import '../bloc/hr_interview_event.dart';
import '../bloc/hr_interview_state.dart';
import '../theme/hr_interview_theme.dart';
import '../widgets/hr_chat_bubble.dart';
import '../widgets/hr_interviewer_header.dart';
import '../widgets/hr_voice_controls_bar.dart';

class HrInterviewPage extends StatelessWidget {
  const HrInterviewPage({super.key});

  static HrInterviewBloc _createBloc() {
    final ds = HrInterviewRemoteDataSourceImpl();
    final repo = HrInterviewRepositoryImpl(ds);
    return HrInterviewBloc(GetHrInterviewUseCase(repo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc()..add(const HrInterviewRequested()),
      child: const _HrInterviewView(),
    );
  }
}

class _HrInterviewView extends StatelessWidget {
  const _HrInterviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HrInterviewTheme.chatBg,
      appBar: const PrepYouAppBar(title: 'HR Interview', showBack: true),
      body: BlocBuilder<HrInterviewBloc, HrInterviewState>(
        builder: (context, state) {
          if (state is HrInterviewLoading ||
              state is HrInterviewInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: HrInterviewTheme.accentGreen,
              ),
            );
          }
          if (state is HrInterviewError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: HrInterviewTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HrInterviewBloc>().add(const HrInterviewRequested()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HrInterviewTheme.accentGreen,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is HrInterviewLoaded) {
            return Column(
              children: [
                HrInterviewerHeader(session: state.session),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    itemCount: state.session.messages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (ctx, index) =>
                        HrChatBubble(message: state.session.messages[index]),
                  ),
                ),
                const HrVoiceControlsBar(),
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
