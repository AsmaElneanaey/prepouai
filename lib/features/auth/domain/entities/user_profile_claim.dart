import 'package:equatable/equatable.dart';

class UserProfileClaim extends Equatable {
  const UserProfileClaim({
    required this.sub,
    required this.email,
    required this.role,
    required this.iat,
    required this.exp,
  });

  final String sub;
  final String email;
  final String role;
  final int iat;
  final int exp;

  @override
  List<Object?> get props => [sub, email, role, iat, exp];
}
