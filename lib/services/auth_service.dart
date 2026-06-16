import 'package:flutter/foundation.dart';
import '../features/auth/domain/entities/user.dart';
import '../core/api/dio_client.dart';
import '../core/services/secure_storage_service.dart';
import '../core/api/api_endpoints.dart';
import '../features/auth/data/models/register_response_dto.dart';

// Simple app-wide auth state. In a real app use Provider or another state management solution.
final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

// Track selected bottom navigation bar index
final ValueNotifier<int> selectedBottomNavIndex = ValueNotifier<int>(0);

// Logged in user details
final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);

// Selected profile picture (bytes for custom upload, or preset avatar URL string)
final ValueNotifier<Uint8List?> userProfileImageBytes =
    ValueNotifier<Uint8List?>(null);
final ValueNotifier<String?> userPresetAvatar = ValueNotifier<String?>(null);

/// Fetches the latest profile data from the backend and updates [currentUser].
Future<void> refreshUserProfile() async {
  try {
    final secureStorageService = SecureStorageService();
    final dioClient = DioClient(secureStorageService);
    final response = await dioClient.dio.get(ApiEndpoints.profile);
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map) {
        final userData = data['data'];
        if (userData is Map) {
          final userMap = userData['user'];
          if (userMap is Map<String, dynamic>) {
            final userDto = UserDto.fromJson(userMap);
            currentUser.value = userDto.toEntity();
          }
        }
      }
    }
  } catch (e) {
    debugPrint('Error refreshing user profile: $e');
  }
}

