import '../../domain/entities/hr_interview_session.dart';
import '../../domain/entities/hr_submit_response.dart';
import '../../domain/entities/hr_next_question.dart';
import '../../domain/repositories/hr_interview_repository.dart';
import '../datasources/hr_interview_remote_data_source.dart';

class HrInterviewRepositoryImpl implements HrInterviewRepository {
  HrInterviewRepositoryImpl(this._remote);

  final HrInterviewRemoteDataSource _remote;

  @override
  Future<HrInterviewSession> getActiveSession() async {
    final model = await _remote.fetchActiveSession();
    return model.toEntity();
  }

  @override
  Future<void> startHrInterviewStage({
    required String id,
    required String focusArea,
  }) async {
    await _remote.startHrStage(id, focusArea);
  }

  @override
  Future<HrSubmitResponse> submitResponse({
    required String id,
    required String responseText,
    String? audioRecordingUrl,
  }) async {
    final dto = await _remote.submitResponse(
      id: id,
      responseText: responseText,
      audioRecordingUrl: audioRecordingUrl,
    );
    return dto.data.toEntity();
  }

  @override
  Future<HrNextQuestion> getNextQuestion(String id) async {
    final dto = await _remote.getNextQuestion(id);
    return dto.data.toEntity();
  }
}
