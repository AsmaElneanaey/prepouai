import '../entities/user.dart';
import '../entities/user_profile_claim.dart';

abstract class AuthRepository {
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> refreshToken(String refreshToken);
  Future<User> oauthCallback(Map<String, dynamic> oauthData);
  Future<UserProfileClaim> getProfile();
}
