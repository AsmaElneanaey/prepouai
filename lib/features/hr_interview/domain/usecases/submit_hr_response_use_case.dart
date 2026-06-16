import '../entities/hr_submit_response.dart';
import '../repositories/hr_interview_repository.dart';

class SubmitHrResponseUseCase {
  const SubmitHrResponseUseCase(this._repository);

  final HrInterviewRepository _repository;

  Future<HrSubmitResponse> call({
    required String id,
    required String responseText,
    String? audioRecordingUrl,
  }) {
    return _repository.submitResponse(
      id: id,
      responseText: responseText,
      audioRecordingUrl: audioRecordingUrl,
    );
  }
}
