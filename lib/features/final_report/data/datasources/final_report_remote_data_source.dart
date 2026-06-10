import '../models/final_report_model.dart';

abstract class FinalReportRemoteDataSource {
  Future<FinalReportModel> fetchFinalReport();
}

class FinalReportRemoteDataSourceImpl implements FinalReportRemoteDataSource {
  @override
  Future<FinalReportModel> fetchFinalReport() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return FinalReportModel(
      overallScore: 86,
      candidateName: 'Alex Johnson',
      candidateRole: 'Senior Frontend Engineer',
      pipelineDateLabel: 'June 9, 2026',
      stageScores: const [
        {
          'stageName': 'CV Screening',
          'score': 91,
          'feedback': 'Excellent alignment in React and TypeScript. Highlight more system metrics.',
          'iconKey': 'cv',
        },
        {
          'stageName': 'MCQ Exam',
          'score': 85,
          'feedback': 'Solid logic skills. 17 out of 20 answered correctly. Keep practicing DSA fundamentals.',
          'iconKey': 'mcq',
        },
        {
          'stageName': 'HR Behavioral',
          'score': 82,
          'feedback': 'Strong communication and Stripe background match. Good story framework.',
          'iconKey': 'hr',
        },
        {
          'stageName': 'Technical Coding',
          'score': 88,
          'feedback': 'Solved twoSum optimally with Hash Map. Clean indentation and naming.',
          'iconKey': 'tech',
        },
      ],
      strengths: const [
        'Robust expertise in Frontend and Mobile framework architectures.',
        'Optimal time-complexity approaches for live algorithm challenges.',
        'High communication rating and structured delivery of behavioral answers.',
      ],
      improvements: const [
        'Expand resume detail on Stripe backend integrations or system scaling.',
        'Deepen understanding of edge constraints (e.g. integer overflow) in live coding.',
        'Improve confidence in answering design pattern architectural tradeoffs.',
      ],
    );
  }
}
