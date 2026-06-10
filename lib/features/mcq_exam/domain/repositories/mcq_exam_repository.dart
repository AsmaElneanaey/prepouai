import '../entities/mcq_exam_session.dart';

abstract class McqExamRepository {
  Future<McqExamSession> getExamSession();
}
