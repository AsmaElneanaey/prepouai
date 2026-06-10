import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/mcq_exam/data/datasources/mcq_exam_remote_data_source.dart';
import 'package:prepouai/features/mcq_exam/data/repositories/mcq_exam_repository_impl.dart';

void main() {
  late McqExamRepositoryImpl repository;

  setUp(() {
    repository = McqExamRepositoryImpl(McqExamRemoteDataSourceImpl());
  });

  test('getExamSession returns 5 questions', () async {
    final session = await repository.getExamSession();

    expect(session.totalQuestions, 5);
    expect(session.durationSeconds, 20 * 60);
    expect(session.questions.first.category, 'React');
    expect(session.questions.first.options, hasLength(4));
  });
}
