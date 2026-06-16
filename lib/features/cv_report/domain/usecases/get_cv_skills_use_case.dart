import '../../../skills/domain/entities/skill.dart';
import '../repositories/cv_report_repository.dart';

class GetCvSkillsUseCase {
  GetCvSkillsUseCase(this._repository);

  final CvReportRepository _repository;

  Future<List<Skill>> call(String id) {
    return _repository.getCvSkills(id);
  }
}
