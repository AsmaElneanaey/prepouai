import '../entities/user_profile_claim.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserProfileClaim> call() {
    return _repository.getProfile();
  }
}
