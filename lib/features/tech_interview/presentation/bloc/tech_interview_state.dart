import 'package:equatable/equatable.dart';
import '../../domain/entities/tech_interview_session.dart';

abstract class TechInterviewState extends Equatable {
  const TechInterviewState();

  @override
  List<Object?> get props => [];
}

class TechInterviewInitial extends TechInterviewState {
  const TechInterviewInitial();
}

class TechInterviewLoading extends TechInterviewState {
  const TechInterviewLoading();
}

class TechInterviewLoaded extends TechInterviewState {
  const TechInterviewLoaded({
    required this.session,
    required this.currentCode,
    required this.currentLanguage,
    required this.terminalOutput,
    required this.isSubmitting,
    required this.isSuccess,
  });

  final TechInterviewSession session;
  final String currentCode;
  final String currentLanguage;
  final String terminalOutput;
  final bool isSubmitting;
  final bool isSuccess;

  TechInterviewLoaded copyWith({
    TechInterviewSession? session,
    String? currentCode,
    String? currentLanguage,
    String? terminalOutput,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return TechInterviewLoaded(
      session: session ?? this.session,
      currentCode: currentCode ?? this.currentCode,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      terminalOutput: terminalOutput ?? this.terminalOutput,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        session,
        currentCode,
        currentLanguage,
        terminalOutput,
        isSubmitting,
        isSuccess,
      ];
}

class TechInterviewError extends TechInterviewState {
  const TechInterviewError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
