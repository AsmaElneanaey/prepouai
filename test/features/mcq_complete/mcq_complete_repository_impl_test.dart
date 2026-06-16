import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/mcq_complete/data/repositories/mcq_complete_repository_impl.dart';
import 'package:prepouai/features/mcq_exam/domain/entities/mcq_exam_session.dart';

void main() {
  late McqCompleteRepositoryImpl repository;

  setUp(() {
    repository = McqCompleteRepositoryImpl();
  });

  McqExamSession buildSession() {
    return McqExamSession(
      durationSeconds: 1200,
      questions: const [
        McqQuestion(
          index: 1,
          category: 'React',
          difficulty: McqDifficulty.medium,
          text: 'Q1',
          options: [],
          correctOptionId: 'B',
          explanation: 'e1',
        ),
        McqQuestion(
          index: 2,
          category: 'TypeScript',
          difficulty: McqDifficulty.medium,
          text: 'Q2',
          options: [],
          correctOptionId: 'A',
          explanation: 'e2',
        ),
        McqQuestion(
          index: 3,
          category: 'Algorithms',
          difficulty: McqDifficulty.medium,
          text: 'Q3',
          options: [],
          correctOptionId: 'B',
          explanation: 'e3',
        ),
        McqQuestion(
          index: 4,
          category: 'System Design',
          difficulty: McqDifficulty.hard,
          text: 'Q4',
          options: [],
          correctOptionId: 'B',
          explanation: 'e4',
        ),
        McqQuestion(
          index: 5,
          category: 'JavaScript',
          difficulty: McqDifficulty.easy,
          text: 'Q5',
          options: [],
          correctOptionId: 'B',
          explanation: 'e5',
        ),
      ],
    );
  }

  test('calculateResult returns 80% and pass for 4 of 5 correct', () {
    final result = repository.calculateResult(
      session: buildSession(),
      selectedAnswers: {0: 'B', 1: 'A', 2: 'B', 3: 'A', 4: 'B'},
    );

    expect(result.scorePercent, 80);
    expect(result.isPass, true);
    expect(result.correctCount, 4);
    expect(result.totalCount, 5);
    expect(result.topics.length, 5);

    final react = result.topics.firstWhere((t) => t.name == 'React');
    expect(react.correct, 1);
    expect(react.total, 1);

    final ts = result.topics.firstWhere((t) => t.name == 'TypeScript');
    expect(ts.correct, 1);
    expect(ts.total, 1);

    final systemDesign = result.topics.firstWhere(
      (t) => t.name == 'System Design',
    );
    expect(systemDesign.correct, 0);
    expect(systemDesign.total, 1);
  });
}
