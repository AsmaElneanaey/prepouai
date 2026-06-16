import '../../domain/entities/mcq_answer_response.dart';
import '../../domain/entities/mcq_complete_response.dart';

class McqAnswerResponseModel {
  const McqAnswerResponseModel({
    required this.isCorrect,
    required this.explanation,
    this.correctOptionIndex,
  });

  factory McqAnswerResponseModel.fromJson(Map<String, dynamic> json) {
    return McqAnswerResponseModel(
      isCorrect: json['isCorrect'] as bool? ?? json['is_correct'] as bool? ?? false,
      explanation: json['explanation'] as String? ?? '',
      correctOptionIndex: json['correct_option_index'] as int?,
    );
  }

  final bool isCorrect;
  final String explanation;
  final int? correctOptionIndex;

  McqAnswerResponse toEntity() {
    return McqAnswerResponse(
      isCorrect: isCorrect,
      explanation: explanation,
      correctOptionIndex: correctOptionIndex,
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
    required this.scorePercent,
    required this.correctCount,
    required this.totalQuestions,
    required this.answeredCount,
  });

  factory McqCompleteResponseModel.fromJson(Map<String, dynamic> json) {
    return McqCompleteResponseModel(
      scorePercent: json['score_pct'] as int? ?? json['scorePercent'] as int? ?? 0,
      correctCount: json['correct_count'] as int? ?? json['correctCount'] as int? ?? 0,
      totalQuestions: json['total_questions'] as int? ?? json['totalQuestions'] as int? ?? 0,
      answeredCount: json['answered_count'] as int? ?? json['answeredCount'] as int? ?? 0,
    );
  }

  final int scorePercent;
  final int correctCount;
  final int totalQuestions;
  final int answeredCount;

  McqCompleteResponse toEntity() {
    return McqCompleteResponse(
      scorePercent: scorePercent,
      correctCount: correctCount,
      totalQuestions: totalQuestions,
      answeredCount: answeredCount,
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
    required this.stageId,
  });

  factory StartMcqResponseDto.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] as Map<String, dynamic>? ?? const {};
    final list = payload['questions'] as List<dynamic>? ?? const [];
    final mcqStage = (payload['mcqStage'] ?? payload['mcq_stage']) as Map<String, dynamic>?;
    final stageId = mcqStage?['stage_id'] as String? ?? mcqStage?['_id'] as String? ?? mcqStage?['id'] as String? ?? '';
    
    final int durationSeconds;
    if (mcqStage != null && mcqStage['time_limit_minutes'] != null) {
      durationSeconds = (mcqStage['time_limit_minutes'] as int) * 60;
    } else {
      durationSeconds = payload['durationSeconds'] as int? ?? payload['duration_seconds'] as int? ?? 1200;
    }

    return StartMcqResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      questions: list.map((e) => e as Map<String, dynamic>).toList(),
      durationSeconds: durationSeconds,
      stageId: stageId,
    );
  }

  final bool success;
  final String message;
  final List<Map<String, dynamic>> questions;
  final int durationSeconds;
  final String stageId;
}
