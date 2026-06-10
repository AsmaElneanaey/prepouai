import 'package:flutter/material.dart';

import '../theme/mcq_complete_theme.dart';

class ContinueHrCta extends StatelessWidget {
  const ContinueHrCta({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: McqCompleteTheme.primaryGreen,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed ??
            () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/hr-interview');
            },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: McqCompleteTheme.primaryGreen.withValues(alpha: 0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue to HR Interview',
                style: TextStyle(
                  color: McqCompleteTheme.pageBackground,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                size: 18,
                color: McqCompleteTheme.pageBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
