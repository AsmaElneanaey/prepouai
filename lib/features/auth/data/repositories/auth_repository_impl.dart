import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_profile_claim.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/register_request_dto.dart';
import '../models/login_request_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorageService,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorageService = secureStorageService;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;

  @override
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final dto = RegisterRequestDto(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    final response = await _remoteDataSource.register(dto);

    // Save tokens securely
    await _secureStorageService.saveAccessToken(response.accessToken);
    await _secureStorageService.saveRefreshToken(response.refreshToken);

    return response.user.toEntity();
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final dto = LoginRequestDto(
      email: email,
      password: password,
    );

    final response = await _remoteDataSource.login(dto);

    // Save tokens securely
    await _secureStorageService.saveAccessToken(response.accessToken);
    await _secureStorageService.saveRefreshToken(response.refreshToken);

    return response.user.toEntity();
  }

  @override
  Future<User> refreshToken(String refreshToken) async {
    final response = await _remoteDataSource.refreshToken(refreshToken);

    // Save tokens securely
    await _secureStorageService.saveAccessToken(response.accessToken);
    await _secureStorageService.saveRefreshToken(response.refreshToken);

    return response.user.toEntity();
  }

  @override
  Future<User> oauthCallback(Map<String, dynamic> oauthData) async {
    final response = await _remoteDataSource.oauthCallback(oauthData);

    // Save tokens securely
    await _secureStorageService.saveAccessToken(response.accessToken);
    await _secureStorageService.saveRefreshToken(response.refreshToken);

    return response.user.toEntity();
  }

  @override
  Future<UserProfileClaim> getProfile() async {
    final response = await _remoteDataSource.getProfile();
    return response.toEntity();
  }
}
