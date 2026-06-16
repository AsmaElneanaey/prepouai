import '../../domain/entities/hr_message.dart';
import '../../domain/entities/hr_submit_response.dart';
import '../../domain/entities/hr_next_question.dart';

class StartHrResponseDto {
  const StartHrResponseDto({
    required this.success,
    required this.message,
  });

  factory StartHrResponseDto.fromJson(Map<String, dynamic> json) {
    return StartHrResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  final bool success;
  final String message;
}

class HrSubmitResponseModel {
  const HrSubmitResponseModel({
    required this.userMessage,
    required this.aiReplyMessage,
  });

  factory HrSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = (json['userMessage'] ?? json['user_message']) as Map<String, dynamic>? ?? const {};
    final aiJson = (json['aiReplyMessage'] ?? json['ai_reply_message']) as Map<String, dynamic>? ?? const {};

    return HrSubmitResponseModel(
      userMessage: HrInterviewMessage(
        sender: (userJson['sender'] as String? ?? 'user').toLowerCase() == 'ai'
            ? HrMessageSender.ai
            : HrMessageSender.user,
        body: userJson['body'] as String? ?? '',
        timestampLabel: userJson['timestamp'] as String? ?? userJson['timestampLabel'] as String? ?? '',
      ),
      aiReplyMessage: HrInterviewMessage(
        sender: (aiJson['sender'] as String? ?? 'ai').toLowerCase() == 'ai'
            ? HrMessageSender.ai
            : HrMessageSender.user,
        body: aiJson['body'] as String? ?? '',
        timestampLabel: aiJson['timestamp'] as String? ?? aiJson['timestampLabel'] as String? ?? '',
      ),
    );
  }

  final HrInterviewMessage userMessage;
  final HrInterviewMessage aiReplyMessage;

  HrSubmitResponse toEntity() {
    return HrSubmitResponse(
      userMessage: userMessage,
      aiReplyMessage: aiReplyMessage,
    );
  }
}

class HrSubmitResponseDto {
  const HrSubmitResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HrSubmitResponseDto.fromJson(Map<String, dynamic> json) {
    return HrSubmitResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: HrSubmitResponseModel.fromJson(json['data'] as Map<String, dynamic>),
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
