import '../../domain/entities/hr_message.dart';
import '../../domain/entities/hr_submit_response.dart';
import '../../domain/entities/hr_next_question.dart';

class StartHrResponseDto {
  const StartHrResponseDto({
    required this.success,
    required this.message,
    required this.question,
    required this.stageId,
  });

  factory StartHrResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final hrStage = data['hrStage'] as Map<String, dynamic>? ?? const {};
    return StartHrResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      question: data['question'] as String? ?? '',
      stageId: hrStage['_id'] as String? ?? hrStage['id'] as String? ?? '',
    );
  }

  final bool success;
  final String message;
  final String question;
  final String stageId;
}

class HrSubmitResponseModel {
  const HrSubmitResponseModel({
    required this.userMessage,
    required this.aiReplyMessage,
    required this.completed,
    this.nextQuestion,
  });

  factory HrSubmitResponseModel.fromJson(Map<String, dynamic> json, String responseText) {
    final userJson = (json['userMessage'] ?? json['user_message']) as Map<String, dynamic>?;
    final aiJson = (json['aiReplyMessage'] ?? json['ai_reply_message']) as Map<String, dynamic>?;

    final completed = json['completed'] as bool? ?? false;
    final nextQuestion = json['question'] as String? ?? (aiJson != null ? aiJson['body'] as String? : null);

    final userMessage = HrInterviewMessage(
      sender: HrMessageSender.user,
      body: userJson != null ? (userJson['body'] as String? ?? responseText) : responseText,
      timestampLabel: userJson != null ? (userJson['timestamp'] as String? ?? '') : '0:00',
    );

    final aiReplyMessage = HrInterviewMessage(
      sender: HrMessageSender.ai,
      body: nextQuestion ?? 'Interview complete.',
      timestampLabel: aiJson != null ? (aiJson['timestamp'] as String? ?? '') : '0:00',
    );

    return HrSubmitResponseModel(
      userMessage: userMessage,
      aiReplyMessage: aiReplyMessage,
      completed: completed,
      nextQuestion: nextQuestion,
    );
  }

  final HrInterviewMessage userMessage;
  final HrInterviewMessage aiReplyMessage;
  final bool completed;
  final String? nextQuestion;

  HrSubmitResponse toEntity() {
    return HrSubmitResponse(
      userMessage: userMessage,
      aiReplyMessage: aiReplyMessage,
      completed: completed,
      nextQuestion: nextQuestion,
    );
  }
}

class HrSubmitResponseDto {
  const HrSubmitResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HrSubmitResponseDto.fromJson(Map<String, dynamic> json, String responseText) {
    final dataVal = json['data'] as Map<String, dynamic>? ?? const {};
    return HrSubmitResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: HrSubmitResponseModel.fromJson(dataVal, responseText),
    );
  }

  final bool success;
  final String message;
  final HrSubmitResponseModel data;
}

class HrNextQuestionModel {
  const HrNextQuestionModel({
    required this.question,
  });

  factory HrNextQuestionModel.fromJson(dynamic json) {
    if (json is String) {
      return HrNextQuestionModel(question: json);
    }
    if (json is Map<String, dynamic>) {
      return HrNextQuestionModel(
        question: json['question'] as String? ?? '',
      );
    }
    return const HrNextQuestionModel(question: '');
  }

  final String question;

  HrNextQuestion toEntity() {
    return HrNextQuestion(
      question: question,
    );
  }
}

class HrNextQuestionDto {
  const HrNextQuestionDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HrNextQuestionDto.fromJson(Map<String, dynamic> json) {
    final dataVal = json['data'];
    return HrNextQuestionDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: HrNextQuestionModel.fromJson(dataVal),
    );
  }

  final bool success;
  final String message;
  final HrNextQuestionModel data;
}
