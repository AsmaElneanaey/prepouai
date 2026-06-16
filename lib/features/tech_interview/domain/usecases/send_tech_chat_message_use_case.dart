import '../repositories/tech_interview_repository.dart';

class SendTechChatMessageUseCase {
  const SendTechChatMessageUseCase(this._repository);

  final TechInterviewRepository _repository;

  Future<String> call({required String id, required String message}) {
    return _repository.sendChatMessage(id: id, message: message);
  }
}
