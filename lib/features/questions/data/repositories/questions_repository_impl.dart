import '../../domain/entities/master_question.dart';
import '../../domain/repositories/questions_repository.dart';
import '../datasources/questions_remote_data_source.dart';

class QuestionsRepositoryImpl implements QuestionsRepository {
  QuestionsRepositoryImpl(this._remoteDataSource);

  final QuestionsRemoteDataSource _remoteDataSource;

  @override
  Future<MasterQuestion> createQuestion({
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
    required String category,
    required String difficulty,
    required List<String> tags,
    required bool isAiGenerated,
    required int estimatedTimeSec,
  }) async {
    final response = await _remoteDataSource.createQuestion(
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
      category: category,
      difficulty: difficulty,
      tags: tags,
      isAiGenerated: isAiGenerated,
      estimatedTimeSec: estimatedTimeSec,
    );
    return response.question.toEntity();
  }

  @override
  Future<List<MasterQuestion>> getQuestions() async {
    final response = await _remoteDataSource.getQuestions();
    return response.questions.map((e) => e.toEntity()).toList();
  }
}
