import '../../domain/entities/user.dart';

class RegisterResponseDto {
  const RegisterResponseDto({
    required this.success,
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final userData = data['user'] as Map<String, dynamic>;

    return RegisterResponseDto(
      success: json['success'] as bool,
      message: json['message'] as String,
      user: UserDto.fromJson(userData),
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
  }

  final bool success;
  final String message;
  final UserDto user;
  final String accessToken;
  final String refreshToken;
}

class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.totalCredits,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.isActive,
    required this.memberSince,
    required this.lastActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      totalCredits: json['total_credits'] as int? ?? 0,
      currentStreakDays: json['current_streak_days'] as int? ?? 0,
      longestStreakDays: json['longest_streak_days'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      memberSince: json['member_since'] as String? ?? '',
      lastActive: json['last_active'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final int totalCredits;
  final int currentStreakDays;
  final int longestStreakDays;
  final bool isActive;
  final String memberSince;
  final String lastActive;
  final String createdAt;
  final String updatedAt;

  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      totalCredits: totalCredits,
      currentStreakDays: currentStreakDays,
      longestStreakDays: longestStreakDays,
      isActive: isActive,
      memberSince: memberSince,
      lastActive: lastActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
