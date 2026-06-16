import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../features/auth/domain/entities/user.dart';

// Simple app-wide auth state. In a real app use Provider or another state management solution.
final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

// Track selected bottom navigation bar index
final ValueNotifier<int> selectedBottomNavIndex = ValueNotifier<int>(0);

// Logged in user details
final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);

// Selected profile picture (bytes for custom upload, or preset avatar URL string)
final ValueNotifier<Uint8List?> userProfileImageBytes = ValueNotifier<Uint8List?>(null);
final ValueNotifier<String?> userPresetAvatar = ValueNotifier<String?>(null);

