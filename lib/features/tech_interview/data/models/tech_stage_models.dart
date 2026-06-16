class TechStageResponseDto {
  const TechStageResponseDto({
    required this.success,
    required this.message,
  });

  factory TechStageResponseDto.fromJson(Map<String, dynamic> json) {
    return TechStageResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  final bool success;
  final String message;
}
