import '../../domain/entities/mcq_answer_response.dart';
import '../../domain/entities/mcq_complete_response.dart';

class McqAnswerResponseModel {
  const McqAnswerResponseModel({
    required this.isCorrect,
    required this.explanation,
  });

  factory McqAnswerResponseModel.fromJson(Map<String, dynamic> json) {
    return McqAnswerResponseModel(
      isCorrect: json['isCorrect'] as bool? ?? json['is_correct'] as bool? ?? false,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  final bool isCorrect;
  final String explanation;

  McqAnswerResponse toEntity() {
    return McqAnswerResponse(
      isCorrect: isCorrect,
      explanation: explanation,
    );
  }
}

class McqAnswerResponseDto {
  const McqAnswerResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory McqAnswerResponseDto.fromJson(Map<String, dynamic> json) {
    return McqAnswerResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: McqAnswerResponseModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final McqAnswerResponseModel data;
}

class McqCompleteResponseModel {
  const McqCompleteResponseModel({
    required this.score,
    required this.badge,
  });

  factory McqCompleteResponseModel.fromJson(Map<String, dynamic> json) {
    return McqCompleteResponseModel(
      score: json['score'] as int? ?? 0,
      badge: json['badge'] as String? ?? '',
    );
  }

  final int score;
  final String badge;

  McqCompleteResponse toEntity() {
    return McqCompleteResponse(
      score: score,
      badge: badge,
    );
  }
}

class McqCompleteResponseDto {
  const McqCompleteResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory McqCompleteResponseDto.fromJson(Map<String, dynamic> json) {
    return McqCompleteResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: McqCompleteResponseModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final McqCompleteResponseModel data;
}

class StartMcqResponseDto {
  const StartMcqResponseDto({
    required this.success,
    required this.message,
    required this.questions,
    required this.durationSeconds,
  });

  factory StartMcqResponseDto.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] as Map<String, dynamic>? ?? const {};
    final list = payload['questions'] as List<dynamic>? ?? const [];
    return StartMcqResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      questions: list.map((e) => e as Map<String, dynamic>).toList(),
      durationSeconds: payload['durationSeconds'] as int? ?? payload['duration_seconds'] as int? ?? 1200,
    );
  }

  final bool success;
  final String message;
  final List<Map<String, dynamic>> questions;
  final int durationSeconds;
}
