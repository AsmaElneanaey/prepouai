import '../../domain/entities/interview_session.dart';

class SessionStageModel {
  const SessionStageModel({
    required this.id,
    required this.sessionId,
    required this.stageType,
    required this.orderIndex,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.score,
    this.badge,
  });

  factory SessionStageModel.fromJson(Map<String, dynamic> json) {
    return SessionStageModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      sessionId: json['session_id'] as String? ?? '',
      stageType: json['stage_type'] as String? ?? '',
      orderIndex: json['order_index'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
      score: json['score'] as int?,
      badge: json['badge'] as String?,
    );
  }

  final String id;
  final String sessionId;
  final String stageType;
  final int orderIndex;
  final String status;
  final String? startedAt;
  final String? completedAt;
  final int? score;
  final String? badge;

  SessionStage toEntity() {
    return SessionStage(
      id: id,
      sessionId: sessionId,
      stageType: stageType,
      orderIndex: orderIndex,
      status: status,
      startedAt: startedAt,
      completedAt: completedAt,
      score: score,
      badge: badge,
    );
  }
}

class SessionModel {
  const SessionModel({
    required this.id,
    required this.userId,
    required this.sessionNumber,
    required this.title,
    required this.targetRole,
    required this.seniorityLevel,
    required this.targetCompanyId,
    required this.status,
    required this.collectedBadges,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
    this.stages = const [],
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final stagesList = json['stages'] as List<dynamic>? ?? const [];
    return SessionModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      sessionNumber: json['session_number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      targetRole: json['target_role'] as String? ?? '',
      seniorityLevel: json['seniority_level'] as String? ?? '',
      targetCompanyId: json['target_company_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      collectedBadges: (json['collected_badges'] as List<dynamic>?) ?? const [],
      startedAt: json['started_at'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      stages: stagesList
          .map((e) => SessionStageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String userId;
  final int sessionNumber;
  final String title;
  final String targetRole;
  final String seniorityLevel;
  final String targetCompanyId;
  final String status;
  final List<dynamic> collectedBadges;
  final String startedAt;
  final String createdAt;
  final String updatedAt;
  final List<SessionStageModel> stages;

  InterviewSession toEntity() {
    return InterviewSession(
      id: id,
      userId: userId,
      sessionNumber: sessionNumber,
      title: title,
      targetRole: targetRole,
      seniorityLevel: seniorityLevel,
      targetCompanyId: targetCompanyId,
      status: status,
      collectedBadges: collectedBadges,
      startedAt: startedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      stages: stages.map((e) => e.toEntity()).toList(),
    );
  }
}

class CreateSessionResponseDto {
  const CreateSessionResponseDto({
    required this.success,
    required this.message,
    required this.session,
  });

  factory CreateSessionResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateSessionResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      session: SessionModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final SessionModel session;
}

class GetSessionsResponseDto {
  const GetSessionsResponseDto({
    required this.success,
    required this.message,
    required this.sessions,
  });

  factory GetSessionsResponseDto.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? const [];
    return GetSessionsResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      sessions: list
          .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final bool success;
  final String message;
  final List<SessionModel> sessions;
}

class GetSessionDetailsResponseDto {
  const GetSessionDetailsResponseDto({
    required this.success,
    required this.message,
    required this.session,
  });

  factory GetSessionDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    return GetSessionDetailsResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      session: SessionModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final SessionModel session;
}

class GetCurrentStageResponseDto {
  const GetCurrentStageResponseDto({
    required this.success,
    required this.message,
    required this.stage,
  });

  factory GetCurrentStageResponseDto.fromJson(Map<String, dynamic> json) {
    return GetCurrentStageResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      stage: SessionStageModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final SessionStageModel stage;
}

class GetPipelineStagesResponseDto {
  const GetPipelineStagesResponseDto({
    required this.success,
    required this.message,
    required this.stages,
  });

  factory GetPipelineStagesResponseDto.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? const [];
    return GetPipelineStagesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      stages: list
          .map((e) => SessionStageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final bool success;
  final String message;
  final List<SessionStageModel> stages;
}

class UpdateStageStatusResponseDto {
  const UpdateStageStatusResponseDto({
    required this.success,
    required this.message,
    required this.stage,
  });

  factory UpdateStageStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return UpdateStageStatusResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      stage: SessionStageModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final SessionStageModel stage;
}
