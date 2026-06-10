import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/final_report/data/datasources/final_report_remote_data_source.dart';
import 'package:prepouai/features/final_report/data/repositories/final_report_repository_impl.dart';

void main() {
  late FinalReportRepositoryImpl repository;

  setUp(() {
    repository =
        FinalReportRepositoryImpl(FinalReportRemoteDataSourceImpl());
  });

  test('getFinalReport returns valid scorecard analysis details', () async {
    final report = await repository.getFinalReport();

    expect(report.candidateName, 'Alex Johnson');
    expect(report.overallScore, 86);
    expect(report.stageScores.length, 4);
    expect(report.strengths.isNotEmpty, true);
    expect(report.improvements.isNotEmpty, true);
  });
}
