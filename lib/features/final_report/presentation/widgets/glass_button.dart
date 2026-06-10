// lib/features/final_report/presentation/widgets/glass_button.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// A reusable glass‑morphism button used on the Final Report screen.
///
/// The button displays [text] with a semi‑transparent frosted‑glass background
/// and an ink splash on tap. It accepts an [onPressed] callback.
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const GlassButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
