import 'package:flutter/material.dart';

import '../../features/cv_report/presentation/theme/cv_report_theme.dart';

class PrepYouAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrepYouAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      backgroundColor: CvReportTheme.pageBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (showBack) ...[
              _IconButton(
                borderRadius: 10,
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                child: const Icon(
                  Icons.chevron_left,
                  color: CvReportTheme.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/bar.png',
                width: 26,
                height: 26,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: CvReportTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: CvReportTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        _IconButton(
          borderRadius: 20,
          onTap: () {},
          child: const Icon(
            Icons.notifications_outlined,
            color: CvReportTheme.textSecondary,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CvReportTheme.primaryGreen, CvReportTheme.skillBlue],
              ),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.onTap,
    required this.child,
    this.borderRadius = 10,
  });

  final VoidCallback onTap;
  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x8030363D),
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(child: child),
        ),
      ),
    );
  }
}
