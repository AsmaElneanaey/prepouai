import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CoachCard extends StatelessWidget {
  const CoachCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3142)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '⚡ AI-POWERED COACH',
            style: TextStyle(
              color: Color(0xFF00D9A3),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ready to land your\ndream job, Alex?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your AI interview coach is ready.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Select Profile tab (index 1) in bottom nav and navigate to pipeline
                selectedBottomNavIndex.value = 1;
                Navigator.pushNamed(context, '/setup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D9A3),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                '⚡ Start New Session',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
           SizedBox(
             width: double.infinity,
             child: OutlinedButton(
               onPressed: () {
                 // Select Profile tab (index 1) in bottom nav and navigate to pipeline
                 selectedBottomNavIndex.value = 1;
                 Navigator.pushNamed(context, '/pipeline');
               },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00D9A3), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Continue Pipeline',
                style: TextStyle(color: Color(0xFF00D9A3), fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

