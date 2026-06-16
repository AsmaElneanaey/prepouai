import '../../domain/entities/master_question.dart';

class MasterQuestionModel {
  const MasterQuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.isAiGenerated,
    required this.estimatedTimeSec,
  });

  factory MasterQuestionModel.fromJson(Map<String, dynamic> json) {
    return MasterQuestionModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      questionText: json['question_text'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      correctOptionIndex: json['correct_option_index'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      isAiGenerated: json['is_ai_generated'] as bool? ?? false,
      estimatedTimeSec: json['estimated_time_sec'] as int? ?? 0,
    );
  }

  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String category;
  final String difficulty;
  final List<String> tags;
  final bool isAiGenerated;
  final int estimatedTimeSec;

  MasterQuestion toEntity() {
    return MasterQuestion(
      id: id,
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
      category: category,
      difficulty: difficulty,
      tags: tags,
      isAiGenerated: isAiGenerated,
      estimatedTimeSec: estimatedTimeSec,
    );
  }
}

class CreateQuestionResponseDto {
  const CreateQuestionResponseDto({
    required this.success,
    required this.message,
    required this.question,
  });

  factory CreateQuestionResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateQuestionResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      question: MasterQuestionModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final MasterQuestionModel question;
}

class GetQuestionsResponseDto {
  const GetQuestionsResponseDto({
    required this.success,
    required this.message,
    required this.questions,
  });

  factory GetQuestionsResponseDto.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? const [];
    return GetQuestionsResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      questions: list
          .map((e) => MasterQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final bool success;
  final String message;
  final List<MasterQuestionModel> questions;
}
