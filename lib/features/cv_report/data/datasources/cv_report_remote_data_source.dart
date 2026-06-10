import '../models/cv_report_model.dart';

abstract class CvReportRemoteDataSource {
  Future<CvReportModel> fetchCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  });
}

class CvReportRemoteDataSourceImpl implements CvReportRemoteDataSource {
  @override
  Future<CvReportModel> fetchCvReport({
    String? cvFileName,
    int? fileSizeBytes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final fileName = cvFileName ?? 'Alex_Johnson_CV_2026.pdf';
    final fileSizeLabel = _formatFileSize(fileSizeBytes ?? 250880);

    return CvReportModel(
      stageLabel: 'Stage 1 of 5',
      title: 'CV Report',
      subtitle: 'AI will analyze your resume and match it to your target role.',
      fileName: fileName,
      fileSizeLabel: fileSizeLabel,
      isParsed: true,
      matchScore: 91,
      candidateName: 'Alex Johnson',
      role: 'Senior Frontend Engineer',
      experienceLabel: '5 years experience',
      filledStars: 4,
      matchLabel: 'Strong match',
      skills: [
        {'name': 'React / Next.js', 'percent': 92, 'barColor': 'blue'},
        {'name': 'TypeScript', 'percent': 88, 'barColor': 'green'},
        {'name': 'Node.js', 'percent': 75, 'barColor': 'purple'},
        {'name': 'System Design', 'percent': 63, 'barColor': 'yellow'},
        {'name': 'DSA', 'percent': 58, 'barColor': 'red'},
      ],
      suggestions: [
        'Add more detail to your system design experience — mention scale metrics.',
        'Include DSA achievements or competitive programming scores if applicable.',
      ],
      experiences: [
        {
          'title': 'Senior Frontend Engineer',
          'company': 'Stripe',
          'period': '2022 – Present',
          'description': 'Led UI architecture for payment dashboard.',
        },
        {
          'title': 'Software Engineer',
          'company': 'Zalando',
          'period': '2019 – 2022',
          'description': 'Built React micro-frontends for e-commerce platform.',
        },
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).round()} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
