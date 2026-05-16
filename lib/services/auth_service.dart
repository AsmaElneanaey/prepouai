import 'package:flutter/foundation.dart';

// Simple app-wide auth state. In a real app use Provider or another state management solution.
final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

// Track selected bottom navigation bar index
final ValueNotifier<int> selectedBottomNavIndex = ValueNotifier<int>(0);

