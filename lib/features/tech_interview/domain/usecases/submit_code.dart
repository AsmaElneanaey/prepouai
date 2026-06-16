import '../repositories/tech_interview_repository.dart';

class SubmitCodeUseCase {
  const SubmitCodeUseCase(this._repository);

  final TechInterviewRepository _repository;

  Future<String> call({
    required String techInterviewId,
    required String problemId,
    required String code,
    required String language,
  }) =>
      _repository.submitCode(
        techInterviewId: techInterviewId,
        problemId: problemId,
        code: code,
        language: language,
      );
}
