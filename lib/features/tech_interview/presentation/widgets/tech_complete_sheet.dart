import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/tech_interview_theme.dart';

class TechCompleteSheet extends StatefulWidget {
  const TechCompleteSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => const TechCompleteSheet(),
    );
  }

  @override
  State<TechCompleteSheet> createState() => _TechCompleteSheetState();
}

class _TechCompleteSheetState extends State<TechCompleteSheet> with SingleTickerProviderStateMixin {
  int _secondsLeft = 3;
  Timer? _timer;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _progressController.reverse(from: 1.0);

    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        _timer?.cancel();
        _navigateToReport();
      } else {
        if (mounted) {
          setState(() {
            _secondsLeft--;
          });
        }
      }
    });
  }

  void _navigateToReport() {
    if (mounted) {
      Navigator.of(context).pop(); // dismiss sheet
      Navigator.of(context).pushReplacementNamed('/final-report');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.48,
      minChildSize: 0.38,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: TechInterviewTheme.cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: TechInterviewTheme.borderMuted),
              left: BorderSide(color: TechInterviewTheme.borderMuted),
              right: BorderSide(color: TechInterviewTheme.borderMuted),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            children: [
              // Pull Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TechInterviewTheme.borderMuted,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Animated Countdown Ring / Checkmark
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulsing glow
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TechInterviewTheme.accentGreen.withValues(alpha: 0.05),
                      ),
                    ),
                    // Progress Indicator
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: _progressController.value,
                            strokeWidth: 4,
                            backgroundColor: const Color(0x3330363D),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              TechInterviewTheme.accentGreen,
                            ),
                          );
                        },
                      ),
                    ),
                    // Seconds number
                    Text(
                      '$_secondsLeft',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Technical Round Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TechInterviewTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              const Text(
                'Excellent job! Your solution successfully passed all the test cases. We are transferring you to your comprehensive interview feedback report.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TechInterviewTheme.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              
              // Direct Go Button
              Material(
                color: TechInterviewTheme.accentGreen,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () {
                    _timer?.cancel();
                    _navigateToReport();
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Final Report',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
