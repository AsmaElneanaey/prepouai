import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
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

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        role,
        totalCredits,
        currentStreakDays,
        longestStreakDays,
        isActive,
        memberSince,
        lastActive,
        createdAt,
        updatedAt,
      ];
}
