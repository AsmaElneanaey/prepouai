import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/main_dashboard.dart';
import 'screens/pipeline_screen.dart';
import 'features/cv_report/presentation/pages/cv_report_page.dart';
import 'features/mcq_exam/presentation/pages/mcq_exam_page.dart';
import 'features/hr_interview/presentation/pages/hr_interview_page.dart';
import 'features/tech_interview/presentation/pages/tech_interview_page.dart';
import 'features/final_report/presentation/pages/final_report_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrepYou.ai',
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/splash': (context) => const SplashScreen(),
        // Both routes load the combined AuthScreen so user can toggle between Sign In and Sign Up
        '/login': (context) => const AuthScreen(),
        '/signup': (context) => const AuthScreen(),
        '/home': (context) => const MainDashboard(),
        '/pipeline': (context) => const PipelineScreen(),
        '/cv-report': (context) => const CvReportPage(),
        '/mcq-exam': (context) => const McqExamPage(),
        '/hr-interview': (context) => const HrInterviewPage(),
        '/tech-interview': (context) => const TechInterviewPage(),
        '/final-report': (context) => const FinalReportPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
