import '../../domain/entities/mcq_exam_session.dart';
import '../../domain/entities/mcq_answer_response.dart';
import '../../domain/entities/mcq_complete_response.dart';
import '../../domain/repositories/mcq_exam_repository.dart';
import '../datasources/mcq_exam_remote_data_source.dart';
import '../models/mcq_exam_model.dart';

class McqExamRepositoryImpl implements McqExamRepository {
  McqExamRepositoryImpl(this._remoteDataSource);

  final McqExamRemoteDataSource _remoteDataSource;

  @override
  Future<McqExamSession> getExamSession() async {
    final model = await _remoteDataSource.fetchExamSession();
    return model.toEntity();
  }

  @override
  Future<McqExamSession> startMcqStage(String id) async {
    final response = await _remoteDataSource.startMcqStage(id);
    final model = McqExamModel(
      questions: response.questions,
      durationSeconds: response.durationSeconds,
      stageId: response.stageId,
    );
    return model.toEntity(id);
  }

  @override
  Future<McqAnswerResponse> submitAnswer({
    required String id,
    required String questionId,
    required int selectedOptionIndex,
    required int timeSpentSeconds,
  }) async {
    final dto = await _remoteDataSource.submitAnswer(
      id: id,
      questionId: questionId,
      selectedOptionIndex: selectedOptionIndex,
      timeSpentSeconds: timeSpentSeconds,
    );
    return dto.data.toEntity();
  }

  @override
  Future<McqCompleteResponse> completeMcqStage(String id) async {
    final dto = await _remoteDataSource.completeMcqStage(id);
    return dto.data.toEntity();
  }
}
