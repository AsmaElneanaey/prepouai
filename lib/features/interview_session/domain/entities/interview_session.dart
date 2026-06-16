import 'package:equatable/equatable.dart';

class SessionStage extends Equatable {
  const SessionStage({
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

  final String id;
  final String sessionId;
  final String stageType;
  final int orderIndex;
  final String status;
  final String? startedAt;
  final String? completedAt;
  final int? score;
  final String? badge;

  @override
  List<Object?> get props => [
        id,
        sessionId,
        stageType,
        orderIndex,
        status,
        startedAt,
        completedAt,
        score,
        badge,
      ];
}

class InterviewSession extends Equatable {
  const InterviewSession({
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
  final List<SessionStage> stages;

  @override
  List<Object?> get props => [
        id,
        userId,
        sessionNumber,
        title,
        targetRole,
        seniorityLevel,
        targetCompanyId,
        status,
        collectedBadges,
        startedAt,
        createdAt,
        updatedAt,
        stages,
      ];
}
