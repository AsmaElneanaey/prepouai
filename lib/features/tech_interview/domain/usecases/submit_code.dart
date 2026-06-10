import '../repositories/tech_interview_repository.dart';

class SubmitCodeUseCase {
  const SubmitCodeUseCase(this._repository);

  final TechInterviewRepository _repository;

  Future<String> call(String code, String language) =>
      _repository.submitCode(code, language);
}
