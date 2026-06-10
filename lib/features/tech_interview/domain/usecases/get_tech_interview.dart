import '../entities/tech_interview_session.dart';
import '../repositories/tech_interview_repository.dart';

class GetTechInterviewUseCase {
  const GetTechInterviewUseCase(this._repository);

  final TechInterviewRepository _repository;

  Future<TechInterviewSession> call() => _repository.getActiveSession();
}
