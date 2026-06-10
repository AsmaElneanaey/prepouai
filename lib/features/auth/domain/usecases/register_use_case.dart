import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return _repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
