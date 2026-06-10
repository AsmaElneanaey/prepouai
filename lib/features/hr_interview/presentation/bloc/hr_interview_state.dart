import 'package:equatable/equatable.dart';

import '../../domain/entities/hr_interview_session.dart';

abstract class HrInterviewState extends Equatable {
  const HrInterviewState();

  @override
  List<Object?> get props => [];
}

class HrInterviewInitial extends HrInterviewState {
  const HrInterviewInitial();
}

class HrInterviewLoading extends HrInterviewState {
  const HrInterviewLoading();
}

class HrInterviewLoaded extends HrInterviewState {
  const HrInterviewLoaded(this.session);

  final HrInterviewSession session;

  @override
  List<Object?> get props => [session];
}

class HrInterviewError extends HrInterviewState {
  const HrInterviewError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
