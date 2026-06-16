import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/core/services/secure_storage_service.dart';
import 'package:prepouai/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prepouai/features/auth/data/models/login_request_dto.dart';
import 'package:prepouai/features/auth/data/models/login_response_dto.dart';
import 'package:prepouai/features/auth/data/models/register_request_dto.dart';
import 'package:prepouai/features/auth/data/models/register_response_dto.dart';
import 'package:prepouai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prepouai/features/auth/domain/entities/user.dart';

class FakeSecureStorageService implements SecureStorageService {
  final Map<String, String> _memStorage = {};

  @override
  Future<void> saveAccessToken(String token) async {
    _memStorage['access_token'] = token;
  }

  @override
  Future<String?> getAccessToken() async {
    return _memStorage['access_token'];
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _memStorage['refresh_token'] = token;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _memStorage['refresh_token'];
  }

  @override
  Future<void> clearTokens() async {
    _memStorage.clear();
  }
}

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<RegisterResponseDto> register(RegisterRequestDto request) async {
    return RegisterResponseDto.fromJson({
      'success': true,
      'message': 'Registration successful',
      'data': {
        'user': {
          'email': request.email,
          'first_name': request.firstName,
          'last_name': request.lastName,
          'role': 'candidate',
          'total_credits': 0,
          'current_streak_days': 0,
          'longest_streak_days': 0,
          'is_active': true,
          'member_since': '2026-06-01T12:00:00.000Z',
          'last_active': '2026-06-01T12:00:00.000Z',
          '_id': 'user-12345',
          'createdAt': '2026-06-01T12:00:00.000Z',
          'updatedAt': '2026-06-01T12:00:00.000Z'
        },
        'access_token': 'new-access-token',
        'refresh_token': 'new-refresh-token'
      }
    });
  }

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    return LoginResponseDto.fromJson({
      'success': true,
      'message': 'Login successful',
      'data': {
        'user': {
          'email': request.email,
          'first_name': 'Mahmoud',
          'last_name': 'Osama',
          'role': 'candidate',
          'total_credits': 10,
          'current_streak_days': 1,
          'longest_streak_days': 5,
          'is_active': true,
          'member_since': '2026-06-01T12:00:00.000Z',
          'last_active': '2026-06-01T12:40:00.000Z',
          '_id': 'user-12345',
          'createdAt': '2026-06-01T12:00:00.000Z',
          'updatedAt': '2026-06-01T12:40:00.000Z'
        },
        'access_token': 'login-access-token',
        'refresh_token': 'login-refresh-token'
      }
    });
  }

  @override
  Future<LoginResponseDto> refreshToken(String refreshToken) async {
    return LoginResponseDto.fromJson({
      'success': true,
      'message': 'Token refreshed successfully',
      'data': {
        'user': {
          'email': 'candidate@example.com',
          'first_name': 'Mahmoud',
          'last_name': 'Osama',
          'role': 'candidate',
          'total_credits': 10,
          'current_streak_days': 1,
          'longest_streak_days': 5,
          'is_active': true,
          'member_since': '2026-06-01T12:00:00.000Z',
          'last_active': '2026-06-01T12:40:00.000Z',
          '_id': 'user-12345',
          'createdAt': '2026-06-01T12:00:00.000Z',
          'updatedAt': '2026-06-01T12:40:00.000Z'
        },
        'access_token': 'refreshed-access-token',
        'refresh_token': 'refreshed-refresh-token'
      }
    });
  }

  @override
  Future<LoginResponseDto> oauthCallback(Map<String, dynamic> oauthData) async {
    return LoginResponseDto.fromJson({
      'success': true,
      'message': 'OAuth registration successful',
      'data': {
        'user': {
          'email': oauthData['email'] as String? ?? 'oauth@example.com',
          'first_name': oauthData['first_name'] as String? ?? 'John',
          'last_name': oauthData['last_name'] as String? ?? 'Doe',
          'role': 'candidate',
          'total_credits': 10,
          'current_streak_days': 1,
          'longest_streak_days': 5,
          'is_active': true,
          'member_since': '2026-06-01T12:00:00.000Z',
          'last_active': '2026-06-01T12:40:00.000Z',
          '_id': 'user-12345',
          'createdAt': '2026-06-01T12:00:00.000Z',
          'updatedAt': '2026-06-01T12:40:00.000Z'
        },
        'access_token': 'oauth-access-token',
        'refresh_token': 'oauth-refresh-token'
      }
    });
  }
}

void main() {
  group('Auth Clean Architecture Test Suite', () {
    late FakeAuthRemoteDataSource fakeDs;
    late FakeSecureStorageService fakeStorage;
    late AuthRepositoryImpl repository;

    setUp(() {
      fakeDs = FakeAuthRemoteDataSource();
      fakeStorage = FakeSecureStorageService();
      repository = AuthRepositoryImpl(
        remoteDataSource: fakeDs,
        secureStorageService: fakeStorage,
      );
    });

    test('register saves access and refresh tokens and returns mapped User entity', () async {
      final User user = await repository.register(
        email: 'candidate@example.com',
        password: 'P@ssword123',
        firstName: 'mahmoud',
        lastName: 'osama',
      );

      expect(user.id, 'user-12345');
      expect(user.email, 'candidate@example.com');
      expect(user.firstName, 'mahmoud');
      expect(user.lastName, 'osama');

      expect(await fakeStorage.getAccessToken(), 'new-access-token');
      expect(await fakeStorage.getRefreshToken(), 'new-refresh-token');
    });

    test('login saves access and refresh tokens and returns mapped User entity', () async {
      final User user = await repository.login(
        email: 'candidate@example.com',
        password: 'P@ssword123',
      );

      expect(user.id, 'user-12345');
      expect(user.email, 'candidate@example.com');
      expect(user.firstName, 'Mahmoud');
      expect(user.lastName, 'Osama');

      expect(await fakeStorage.getAccessToken(), 'login-access-token');
      expect(await fakeStorage.getRefreshToken(), 'login-refresh-token');
    });

    test('refreshToken saves new tokens and returns mapped User entity', () async {
      final User user = await repository.refreshToken('old-refresh-token');

      expect(user.id, 'user-12345');
      expect(user.firstName, 'Mahmoud');

      expect(await fakeStorage.getAccessToken(), 'refreshed-access-token');
      expect(await fakeStorage.getRefreshToken(), 'refreshed-refresh-token');
    });

    test('oauthCallback saves credentials and returns mapped User entity', () async {
      final User user = await repository.oauthCallback({
        'provider': 'google',
        'provider_account_id': '1234567890',
        'email': 'oauth@example.com',
        'first_name': 'John',
        'last_name': 'Doe',
        'access_token': 'google-token',
        'refresh_token': 'google-refresh-token',
        'expires_at': '2026-06-08T17:21:34.000Z'
      });

      expect(user.id, 'user-12345');
      expect(user.email, 'oauth@example.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');

      expect(await fakeStorage.getAccessToken(), 'oauth-access-token');
      expect(await fakeStorage.getRefreshToken(), 'oauth-refresh-token');
    });
  });
}
