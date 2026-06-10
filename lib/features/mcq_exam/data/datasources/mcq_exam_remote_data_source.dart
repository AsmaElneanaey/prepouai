import '../models/mcq_exam_model.dart';

abstract class McqExamRemoteDataSource {
  Future<McqExamModel> fetchExamSession();
}

class McqExamRemoteDataSourceImpl implements McqExamRemoteDataSource {
  static const _sampleQuestions = [
    {
      'category': 'React',
      'difficulty': 'medium',
      'text':
          'Which hook should you use when you need to synchronize a React component with an external system?',
      'options': [
        {'id': 'A', 'label': 'useState'},
        {'id': 'B', 'label': 'useEffect'},
        {'id': 'C', 'label': 'useRef'},
        {'id': 'D', 'label': 'useMemo'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'useEffect runs side effects after render and is the standard hook for syncing with external systems.',
    },
    {
      'category': 'TypeScript',
      'difficulty': 'medium',
      'text':
          'What is the primary purpose of the `readonly` modifier in TypeScript?',
      'options': [
        {'id': 'A', 'label': 'Prevent reassignment of properties'},
        {'id': 'B', 'label': 'Make variables private'},
        {'id': 'C', 'label': 'Enable runtime type checks'},
        {'id': 'D', 'label': 'Convert types to interfaces'},
      ],
      'correctOptionId': 'A',
      'explanation':
          'readonly prevents reassignment of properties on objects and interfaces at compile time.',
    },
    {
      'category': 'Algorithms',
      'difficulty': 'medium',
      'text': 'What is the average time complexity of binary search?',
      'options': [
        {'id': 'A', 'label': 'O(n)'},
        {'id': 'B', 'label': 'O(log n)'},
        {'id': 'C', 'label': 'O(n log n)'},
        {'id': 'D', 'label': 'O(1)'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Binary search halves the search space each step, giving O(log n) average time.',
    },
    {
      'category': 'System Design',
      'difficulty': 'hard',
      'text': 'What does horizontal scaling primarily improve?',
      'options': [
        {'id': 'A', 'label': 'Single-machine CPU clock speed'},
        {'id': 'B', 'label': 'Capacity by adding more machines'},
        {'id': 'C', 'label': 'Database index size'},
        {'id': 'D', 'label': 'Client bundle size'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Horizontal scaling adds more nodes to distribute load and increase throughput.',
    },
    {
      'category': 'JavaScript',
      'difficulty': 'easy',
      'text':
          'What does the `Promise.all()` method do when one of the promises rejects?',
      'options': [
        {'id': 'A', 'label': 'It waits for all promises to settle'},
        {'id': 'B', 'label': 'It immediately rejects with that reason'},
        {'id': 'C', 'label': 'It ignores the rejection'},
        {'id': 'D', 'label': 'It returns undefined for that promise'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Promise.all() fails fast — if any promise rejects, the entire Promise.all() rejects immediately.',
    },
    {
      'category': 'Node.js',
      'difficulty': 'easy',
      'text': 'Which module system is natively supported in modern Node.js?',
      'options': [
        {'id': 'A', 'label': 'AMD'},
        {'id': 'B', 'label': 'CommonJS and ESM'},
        {'id': 'C', 'label': 'UMD only'},
        {'id': 'D', 'label': 'SystemJS'},
      ],
      'correctOptionId': 'B',
      'explanation':
          'Node.js supports both CommonJS (require) and ECMAScript modules (import).',
    },
  ];

  @override
  Future<McqExamModel> fetchExamSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final questions = List<Map<String, dynamic>>.generate(5, (i) {
      final sample = _sampleQuestions[i % _sampleQuestions.length];
      return Map<String, dynamic>.from(sample);
    });

    return McqExamModel(
      questions: questions,
      durationSeconds: 20 * 60,
    );
  }
}
