import 'package:flutter/material.dart';
import '../generated/assets.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true; // true for Sign In, false for Sign Up
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _selectedIndex = 0;

  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Logo
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D9A3).withAlpha(102),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Assets.container.image(
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              // App Name
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'PrepYou.',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'ai',
                      style: TextStyle(color: Color(0xFF00D9A3)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'AI-powered interview coach',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),
              // Auth Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF181E2A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF232A3A)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tabs
                    Row(
                      children: [
                        // Sign In Tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _isSignIn = true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _isSignIn
                                    ? const Color(0xFF232A3A)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Sign Up Tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _isSignIn = false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !_isSignIn
                                    ? const Color(0xFF232A3A)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: !_isSignIn
                                      ? Colors.white
                                      : const Color(0xFF6B7687),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Content based on selected tab
                    if (_isSignIn) _buildSignInContent() else _buildSignUpContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // No bottom navigation bar on the auth screen. Navigation bar is shown only after login.
    );
  }

  Widget _buildSignInContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email
        const Text(
          'Email address',
          style: TextStyle(
            color: Color(0xFF6B7687),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF10141B),
            hintText: 'alex@example.com',
            hintStyle: const TextStyle(color: Color(0xFF6B7687)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
        const SizedBox(height: 18),
        // Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Password',
              style: TextStyle(
                color: Color(0xFF6B7687),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  color: Color(0xFF00D9A3),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF10141B),
            hintText: '••••••••',
            hintStyle: const TextStyle(color: Color(0xFF6B7687)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF6B7687),
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Sign In Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9A3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // mark user as logged in and open main dashboard
              selectedBottomNavIndex.value = 0; // Reset to Home tab
              isLoggedIn.value = true;
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Divider with text
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Color(0xFF232A3A),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Color(0xFF232A3A),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        // Google Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF232A3A)),
              backgroundColor: const Color(0xFF10141B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png',
              width: 22,
              height: 22,
            ),
            label: const Text(
              'Continue with Google',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name
        const Text(
          'Full Name',
          style: TextStyle(
            color: Color(0xFF6B7687),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF10141B),
            hintText: 'John Doe',
            hintStyle: const TextStyle(color: Color(0xFF6B7687)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
        const SizedBox(height: 18),
        // Email
        const Text(
          'Email address',
          style: TextStyle(
            color: Color(0xFF6B7687),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF10141B),
            hintText: 'alex@example.com',
            hintStyle: const TextStyle(color: Color(0xFF6B7687)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
        const SizedBox(height: 18),
        // Password
        const Text(
          'Password',
          style: TextStyle(
            color: Color(0xFF6B7687),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF10141B),
            hintText: '••••••••',
            hintStyle: const TextStyle(color: Color(0xFF6B7687)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF6B7687),
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Confirm Password
        const Text(
          'Confirm Password',
          style: TextStyle(
            color: Color(0xFF6B7687),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF10141B),
            hintText: '••••••••',
            hintStyle: const TextStyle(color: Color(0xFF6B7687)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF6B7687),
              ),
              onPressed: () {
                setState(() =>
                    _obscureConfirmPassword = !_obscureConfirmPassword);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Sign Up Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9A3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // mark user as logged in and open main dashboard
              selectedBottomNavIndex.value = 0; // Reset to Home tab
              isLoggedIn.value = true;
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Divider with text
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Color(0xFF232A3A),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Color(0xFF232A3A),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        // Google Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF232A3A)),
              backgroundColor: const Color(0xFF10141B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png',
              width: 22,
              height: 22,
            ),
            label: const Text(
              'Continue with Google',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

