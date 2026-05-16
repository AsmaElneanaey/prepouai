import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_dashboard.dart';
import 'screens/setup_screen.dart';
import 'screens/pipeline_screen.dart';
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
        '/setup': (context) => const SetupScreen(),
        '/pipeline': (context) => const PipelineScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
