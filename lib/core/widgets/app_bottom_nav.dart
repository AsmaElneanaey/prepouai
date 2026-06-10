import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1117),
        border: Border(
          top: BorderSide(color: Color(0xCC30363D)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 63,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => _onTap(context, 0),
              ),
              _NavItem(
                icon: Icons.show_chart_rounded,
                label: 'Pipeline',
                isSelected: currentIndex == 1,
                showDot: currentIndex == 1,
                onTap: () => _onTap(context, 1),
              ),
              _NavItem(
                icon: Icons.access_time_rounded,
                label: 'History',
                isSelected: currentIndex == 2,
                onTap: () => _onTap(context, 2),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isSelected: currentIndex == 3,
                onTap: () => _onTap(context, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    selectedBottomNavIndex.value = index;
    switch (index) {
      case 0:
        if (currentIndex != 0) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        break;
      case 1:
        if (currentIndex != 1) {
          Navigator.pushReplacementNamed(context, '/pipeline');
        }
        break;
      case 2:
      case 3:
        break;
    }
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool showDot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF00C896);
    const inactiveColor = Color(0xFF6E7681);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                if (showDot)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0D1117),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: activeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
