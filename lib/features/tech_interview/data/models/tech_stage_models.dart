class StartTechResponseDto {
  const StartTechResponseDto({
    required this.success,
    required this.message,
    required this.stageId,
    required this.problemId,
    required this.problemTitle,
    required this.problemDescription,
    required this.problemDifficulty,
    required this.problemStarterCode,
    required this.problemLanguage,
  });

  factory StartTechResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final techStage = data['techStage'] as Map<String, dynamic>? ?? const {};
    final problem = data['problem'] as Map<String, dynamic>? ?? const {};

    final starterCodes = problem['starter_codes'] as List<dynamic>? ?? const [];
    final starterCodeMap = starterCodes.isNotEmpty ? starterCodes.first as Map<String, dynamic> : const {};

    return StartTechResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      stageId: techStage['_id'] as String? ?? techStage['id'] as String? ?? '',
      problemId: problem['_id'] as String? ?? problem['id'] as String? ?? '',
      problemTitle: problem['title'] as String? ?? '',
      problemDescription: problem['description'] as String? ?? '',
      problemDifficulty: problem['difficulty'] as String? ?? 'easy',
      problemStarterCode: starterCodeMap['code'] as String? ?? '',
      problemLanguage: starterCodeMap['language'] as String? ?? 'javascript',
    );
  }

  final bool success;
  final String message;
  final String stageId;
  final String problemId;
  final String problemTitle;
  final String problemDescription;
  final String problemDifficulty;
  final String problemStarterCode;
  final String problemLanguage;
}

class CompleteTechResponseDto {
  const CompleteTechResponseDto({
    required this.success,
    required this.message,
  });

  factory CompleteTechResponseDto.fromJson(Map<String, dynamic> json) {
    return CompleteTechResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  final bool success;
  final String message;
}
