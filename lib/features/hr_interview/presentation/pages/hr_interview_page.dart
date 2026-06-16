import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/prepyou_app_bar.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/datasources/hr_interview_remote_data_source.dart';
import '../../data/repositories/hr_interview_repository_impl.dart';
import '../../domain/usecases/get_hr_interview.dart';
import '../../domain/usecases/submit_hr_response_use_case.dart';
import '../bloc/hr_interview_bloc.dart';
import '../bloc/hr_interview_event.dart';
import '../bloc/hr_interview_state.dart';
import '../theme/hr_interview_theme.dart';
import '../widgets/hr_chat_bubble.dart';
import '../widgets/hr_complete_sheet.dart';
import '../widgets/hr_interviewer_header.dart';
import '../widgets/hr_voice_controls_bar.dart';

class HrInterviewPage extends StatelessWidget {
  const HrInterviewPage({super.key});

  static HrInterviewBloc _createBloc() {
    final secureStorageService = SecureStorageService();
    final dioClient = DioClient(secureStorageService);
    final ds = HrInterviewRemoteDataSourceImpl(dioClient.dio);
    final repo = HrInterviewRepositoryImpl(ds);
    return HrInterviewBloc(
      GetHrInterviewUseCase(repo),
      SubmitHrResponseUseCase(repo),
    );
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

  void _submitVoiceMock(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recording verbal answer...'),
        backgroundColor: HrInterviewTheme.accentGreen,
        duration: Duration(seconds: 1),
      ),
    );
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!context.mounted) return;
      context.read<HrInterviewBloc>().add(
        const HrResponseSubmitted(
          'Here is my recorded verbal response details about resolving team conflicts collaboratively.',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HrInterviewTheme.chatBg,
      appBar: const PrepYouAppBar(title: 'HR Interview', showBack: true),
      body: BlocConsumer<HrInterviewBloc, HrInterviewState>(
        listener: (context, state) {
          if (state is HrInterviewCompleted) {
            HrCompleteSheet.show(context);
          }
        },
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

          final session = state is HrInterviewLoaded
              ? state.session
              : (state is HrInterviewCompleted ? state.session : null);
          final isSubmitting = state is HrInterviewLoaded ? state.isSubmitting : false;

          if (session != null) {
            return Column(
              children: [
                HrInterviewerHeader(session: session),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    itemCount: session.messages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (ctx, index) =>
                        HrChatBubble(message: session.messages[index]),
                  ),
                ),
                if (state is HrInterviewLoaded)
                  _HrInterviewInputBar(isSubmitting: isSubmitting),
                HrVoiceControlsBar(
                  onMicTap: () => _submitVoiceMock(context),
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

class _HrInterviewInputBar extends StatefulWidget {
  const _HrInterviewInputBar({required this.isSubmitting});

  final bool isSubmitting;

  @override
  State<_HrInterviewInputBar> createState() => _HrInterviewInputBarState();
}

class _HrInterviewInputBarState extends State<_HrInterviewInputBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<HrInterviewBloc>().add(HrResponseSubmitted(text));
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: HrInterviewTheme.controlsBarBg,
        border: Border(
          top: BorderSide(color: HrInterviewTheme.borderMuted, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: HrInterviewTheme.aiBubbleBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: HrInterviewTheme.borderMuted, width: 0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: HrInterviewTheme.textPrimary, fontSize: 13),
                cursorColor: HrInterviewTheme.accentGreen,
                enabled: !widget.isSubmitting,
                decoration: const InputDecoration(
                  hintText: 'Type your answer here...',
                  hintStyle: TextStyle(color: HrInterviewTheme.textSecondary, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          widget.isSubmitting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: HrInterviewTheme.accentGreen,
                    strokeWidth: 2,
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: HrInterviewTheme.accentGreen,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.black, size: 16),
                    onPressed: _submit,
                  ),
                ),
        ],
      ),
    );
  }
}
