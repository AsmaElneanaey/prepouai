import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/cv_report/data/datasources/cv_report_remote_data_source.dart';
import 'package:prepouai/features/cv_report/data/repositories/cv_report_repository_impl.dart';

void main() {
  late CvReportRepositoryImpl repository;

  setUp(() {
    repository = CvReportRepositoryImpl(CvReportRemoteDataSourceImpl());
  });

  test('getCvReport returns entity with match score 91', () async {
    final report = await repository.getCvReport();

    expect(report.matchScore.score, 91);
    expect(report.skills, hasLength(5));
    expect(report.experiences, hasLength(2));
  });

  test('getCvReport uses provided file name', () async {
    final report = await repository.getCvReport(
      cvFileName: 'custom_cv.pdf',
    );

    expect(report.file.fileName, 'custom_cv.pdf');
  });
}
