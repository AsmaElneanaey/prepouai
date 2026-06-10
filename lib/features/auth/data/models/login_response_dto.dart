import 'register_response_dto.dart';

class LoginResponseDto {
  const LoginResponseDto({
    required this.success,
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final userData = data['user'] as Map<String, dynamic>;

    return LoginResponseDto(
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
