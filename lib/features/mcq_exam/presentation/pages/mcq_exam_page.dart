import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/prepyou_app_bar.dart';
import '../../../mcq_complete/data/repositories/mcq_complete_repository_impl.dart';
import '../../../mcq_complete/domain/usecases/calculate_mcq_result.dart';
import '../../../mcq_complete/presentation/widgets/mcq_complete_sheet.dart';
import '../../data/datasources/mcq_exam_remote_data_source.dart';
import '../../data/repositories/mcq_exam_repository_impl.dart';
import '../../domain/entities/mcq_option.dart';
import '../../domain/usecases/get_mcq_exam.dart';
import '../bloc/mcq_exam_bloc.dart';
import '../bloc/mcq_exam_event.dart';
import '../bloc/mcq_exam_state.dart';
import '../theme/mcq_exam_theme.dart';
import '../widgets/answer_feedback_card.dart';
import '../widgets/answer_option_tile.dart';
import '../widgets/exam_navigation_bar.dart';
import '../widgets/exam_progress_header.dart';
import '../widgets/question_card.dart';

class McqExamPage extends StatelessWidget {
  const McqExamPage({super.key});

  static McqExamBloc _createBloc() {
    final examDataSource = McqExamRemoteDataSourceImpl();
    final examRepository = McqExamRepositoryImpl(examDataSource);
    final getMcqExam = GetMcqExamUseCase(examRepository);
    final calculateResult =
        CalculateMcqResultUseCase(McqCompleteRepositoryImpl());
    return McqExamBloc(getMcqExam, calculateResult);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc()..add(const McqExamRequested()),
      child: const _McqExamView(),
    );
  }
}

class _McqExamView extends StatelessWidget {
  const _McqExamView();

  AnswerOptionVisualState _optionVisualState(
    McqExamInProgress state,
    McqOption option,
  ) {
    if (!state.isFeedbackVisible) {
      return state.selectedOptionId == option.id
          ? AnswerOptionVisualState.selected
          : AnswerOptionVisualState.idle;
    }

    final isCorrect = option.id == state.currentQuestion.correctOptionId;
    final isSelected = state.selectedOptionId == option.id;

    if (isCorrect && isSelected) {
      return AnswerOptionVisualState.selectedCorrect;
    }
    if (isSelected && !isCorrect) {
      return AnswerOptionVisualState.selectedWrong;
    }
    if (isCorrect) {
      return AnswerOptionVisualState.selectedCorrect;
    }
    return AnswerOptionVisualState.disabled;
  }

  Widget _buildExamBody(BuildContext context, McqExamInProgress state) {
    final question = state.currentQuestion;

    return Column(
      children: [
        ExamProgressHeader(state: state),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuestionCard(question: question),
                const SizedBox(height: 12),
                ...question.options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnswerOptionTile(
                      option: option,
                      visualState: _optionVisualState(state, option),
                      onTap: () {
                        context.read<McqExamBloc>().add(
                              McqAnswerSelected(option.id),
                            );
                      },
                    ),
                  ),
                ),
                if (state.isFeedbackVisible) ...[
                  const SizedBox(height: 4),
                  AnswerFeedbackCard(
                    isCorrect: state.isCurrentAnswerCorrect ?? false,
                    explanation: question.explanation,
                  ),
                ],
              ],
            ),
          ),
        ),
        ExamNavigationBar(
          canGoPrevious: state.canGoPrevious,
          canGoNext: state.canGoNext,
          showFinish: state.isLastQuestion,
          canFinish: state.canFinish,
          onPrevious: () {
            context.read<McqExamBloc>().add(const McqPreviousPressed());
          },
          onNext: () {
            context.read<McqExamBloc>().add(const McqNextPressed());
          },
          onFinish: () {
            context.read<McqExamBloc>().add(const McqFinishPressed());
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: McqExamTheme.pageBackground,
      appBar: const PrepYouAppBar(title: 'MCQ Exam', showBack: true),
      body: BlocConsumer<McqExamBloc, McqExamState>(
        listenWhen: (previous, current) => current is McqExamFinished,
        listener: (context, state) {
          if (state is McqExamFinished) {
            McqCompleteSheet.show(context, state.result);
          }
        },
        builder: (context, state) {
          if (state is McqExamLoading || state is McqExamInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: McqExamTheme.primaryGreen,
              ),
            );
          }

          if (state is McqExamError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: McqExamTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<McqExamBloc>().add(const McqExamRequested());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: McqExamTheme.primaryGreen,
                        foregroundColor: McqExamTheme.pageBackground,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is McqExamTimeUp) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Time is up!',
                      style: TextStyle(
                        color: McqExamTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You answered ${state.selectedAnswers.length} of ${state.session.totalQuestions} questions.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: McqExamTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: McqExamTheme.primaryGreen,
                        foregroundColor: McqExamTheme.pageBackground,
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is McqExamInProgress) {
            return _buildExamBody(context, state);
          }

          if (state is McqExamFinished) {
            return _buildExamBody(context, state.examState);
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
