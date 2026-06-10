import '../entities/hr_interview_session.dart';
import '../repositories/hr_interview_repository.dart';

class GetHrInterviewUseCase {
  const GetHrInterviewUseCase(this._repository);

  final HrInterviewRepository _repository;

  Future<HrInterviewSession> call() => _repository.getActiveSession();
}
