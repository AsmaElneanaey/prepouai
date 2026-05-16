import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
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
                child:Image.asset('assets/bar.png'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lightning Icon with Glow
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D9A3).withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 12,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00D9A3),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flash_on_rounded,
                      size: 60,
                      color: Color(0xFF00D9A3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                "You're All Set.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              const Text(
                'Complete all 5 stages to get your\nreadiness score.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6B7687),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Stages Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF181E2A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF232A3A)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildStageItem(
                      icon: Icons.upload_file_rounded,
                      iconColor: const Color(0xFF00D9A3),
                      title: 'CV Upload',
                      subtitle: 'Resume analysis',
                      duration: '~5 min',
                    ),
                    const Divider(
                      color: Color(0xFF232A3A),
                      height: 24,
                      thickness: 1,
                    ),
                    _buildStageItem(
                      icon: Icons.description_rounded,
                      iconColor: const Color(0xFF0080FF),
                      title: 'MCQ Exam',
                      subtitle: 'Technical aptitude',
                      duration: '~20 min',
                    ),
                    const Divider(
                      color: Color(0xFF232A3A),
                      height: 24,
                      thickness: 1,
                    ),
                    _buildStageItem(
                      icon: Icons.person_rounded,
                      iconColor: const Color(0xFF7C3AED),
                      title: 'HR Interview',
                      subtitle: 'Behavioural round',
                      duration: '~15 min',
                    ),
                    const Divider(
                      color: Color(0xFF232A3A),
                      height: 24,
                      thickness: 1,
                    ),
                    _buildStageItem(
                      icon: Icons.code_rounded,
                      iconColor: const Color(0xFFFB923C),
                      title: 'Tech Interview',
                      subtitle: 'Live coding round',
                      duration: '~30 min',
                    ),
                    const Divider(
                      color: Color(0xFF232A3A),
                      height: 24,
                      thickness: 1,
                    ),
                    _buildStageItem(
                      icon: Icons.bar_chart_rounded,
                      iconColor: const Color(0xFFEF4444),
                      title: 'Final Report',
                      subtitle: 'Readiness score',
                      duration: 'Instant',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Total Session Time
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 20,
                    color: Color(0xFF6B7687),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Total session time: ',
                    style: TextStyle(
                      color: Color(0xFF6B7687),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    '~70 minutes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Start Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D9A3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    // Navigate to pipeline configuration screen
                    selectedBottomNavIndex.value = 1; // Set to Pipeline tab
                    Navigator.pushReplacementNamed(context, '/pipeline');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Let's Start",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
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
              Navigator.pushReplacementNamed(context, '/home');
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
            label: 'Profile',
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

  Widget _buildStageItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String duration,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7687),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Duration
          Text(
            duration,
            style: const TextStyle(
              color: Color(0xFF6B7687),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

