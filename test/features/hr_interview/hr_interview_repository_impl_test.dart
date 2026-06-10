import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/hr_interview/data/datasources/hr_interview_remote_data_source.dart';
import 'package:prepouai/features/hr_interview/data/repositories/hr_interview_repository_impl.dart';
import 'package:prepouai/features/hr_interview/domain/entities/hr_message.dart';

void main() {
  late HrInterviewRepositoryImpl repository;

  setUp(() {
    repository =
        HrInterviewRepositoryImpl(HrInterviewRemoteDataSourceImpl());
  });

  test('getActiveSession returns mock transcript', () async {
    final session = await repository.getActiveSession();

    expect(session.messages.length, 3);
    expect(session.messages.first.sender, HrMessageSender.ai);
    expect(session.liveQuestionCue, '"Tell me about yourself."');
  });
}
