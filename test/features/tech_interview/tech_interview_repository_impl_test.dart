import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/tech_interview/data/datasources/tech_interview_remote_data_source.dart';
import 'package:prepouai/features/tech_interview/data/repositories/tech_interview_repository_impl.dart';
import 'package:prepouai/features/tech_interview/domain/entities/tech_chat_message.dart';

void main() {
  late TechInterviewRepositoryImpl repository;

  setUp(() {
    repository =
        TechInterviewRepositoryImpl(TechInterviewRemoteDataSourceImpl());
  });

  test('getActiveSession returns mock live coding round details', () async {
    final session = await repository.getActiveSession();

    expect(session.messages.length, 1);
    expect(session.messages.first.sender, TechMessageSender.ai);
    expect(session.question.title, 'Two Sum');
    expect(session.question.difficulty.name, 'easy');
  });

  test('submitCode returns test failures for empty code submission', () async {
    final result = await repository.submitCode('', 'dart');

    expect(result, contains('failed'));
    expect(result, contains('Expected: [0,1], Got: []'));
  });

  test('submitCode returns test successes for actual solution code submission', () async {
    final result = await repository.submitCode('// some implementation here', 'dart');

    expect(result, contains('All tests passed!'));
    expect(result, contains('Time Complexity: O(N)'));
  });
}
