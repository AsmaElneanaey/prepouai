import '../../domain/entities/user_profile_claim.dart';

class UserProfileClaimDto {
  const UserProfileClaimDto({
    required this.sub,
    required this.email,
    required this.role,
    required this.iat,
    required this.exp,
  });

  factory UserProfileClaimDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UserProfileClaimDto(
      sub: data['sub'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? '',
      iat: data['iat'] as int? ?? 0,
      exp: data['exp'] as int? ?? 0,
    );
  }

  final String sub;
  final String email;
  final String role;
  final int iat;
  final int exp;

  UserProfileClaim toEntity() {
    return UserProfileClaim(
      sub: sub,
      email: email,
      role: role,
      iat: iat,
      exp: exp,
    );
  }
}
