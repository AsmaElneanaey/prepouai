import '../repositories/hr_interview_repository.dart';

class StartHrInterviewStageUseCase {
  const StartHrInterviewStageUseCase(this._repository);

  final HrInterviewRepository _repository;

  Future<void> call({
    required String id,
    required String focusArea,
  }) {
    return _repository.startHrInterviewStage(
      id: id,
      focusArea: focusArea,
    );
  }
}
