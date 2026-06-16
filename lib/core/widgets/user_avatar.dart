import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../features/cv_report/presentation/theme/cv_report_theme.dart';
import '../../features/auth/domain/entities/user.dart';


class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.size = 32.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable: currentUser,
      builder: (context, user, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: userPresetAvatar,
          builder: (context, presetUrl, _) {
            return ValueListenableBuilder<dynamic>(
              valueListenable: userProfileImageBytes,
              builder: (context, profileBytes, _) {
                Widget avatarContent;

                if (profileBytes != null) {
                  // 1. Custom uploaded image
                  avatarContent = ClipOval(
                    child: Image.memory(
                      profileBytes,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (presetUrl != null && presetUrl.isNotEmpty) {
                  // 2. Preset robot avatar
                  avatarContent = Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10141B),
                      border: Border.all(
                        color: const Color(0xFF00D9A3).withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: Image.network(
                        presetUrl,
                        width: size,
                        height: size,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(user, size),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: size,
                            height: size,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF00D9A3).withOpacity(0.5),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  // 3. Fallback to name initials or generic profile
                  avatarContent = _buildInitialsFallback(user, size);
                }

                return SizedBox(
                  width: size,
                  height: size,
                  child: avatarContent,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildInitialsFallback(User? user, double size) {
    final String initial = (user != null && user.firstName.isNotEmpty)
        ? user.firstName[0].toUpperCase()
        : 'A';

    // Premium styling: nice gradient matching the theme
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00D9A3), // primaryGreen
            Color(0xFF0A66C2), // skillBlue (from theme/appbar gradient)
          ],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.44, // Responsive text size
          ),
        ),
      ),
    );
  }
}
