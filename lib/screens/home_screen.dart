import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/coach_card.dart';
import '../widgets/progress_section.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/interview_list_section.dart';
import '../widgets/credits_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _bottomNavIndex;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = selectedBottomNavIndex.value;
    selectedBottomNavIndex.addListener(_onBottomNavIndexChanged);
  }

  @override
  void dispose() {
    selectedBottomNavIndex.removeListener(_onBottomNavIndexChanged);
    super.dispose();
  }

  void _onBottomNavIndexChanged() {
    setState(() {
      _bottomNavIndex = selectedBottomNavIndex.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1419),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF00D9A3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset('assets/bar.png'),
              ),
            ),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'PrepYou.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: 'ai',
                    style: TextStyle(
                      color: Color(0xFF00D9A3),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF6B7687)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CoachCard(),
              const SizedBox(height: 24),
              const ProgressSection(),
              const SizedBox(height: 24),
              const QuickAccessSection(),
              const SizedBox(height: 24),
              const InterviewListSection(),
              const SizedBox(height: 24),
              const CreditsSection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF181E2A),
        selectedItemColor: const Color(0xFF00D9A3),
        unselectedItemColor: const Color(0xFF6B7687),
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
          selectedBottomNavIndex.value = index;
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/pipeline');
              break;
            case 2:
              // History - can be implemented later
              break;
            case 3:
              // Settings - can be implemented later
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            label: 'Pipeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
