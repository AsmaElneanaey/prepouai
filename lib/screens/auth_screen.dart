import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../generated/assets.dart';
import '../services/auth_service.dart';
import '../core/api/dio_client.dart';
import '../core/services/secure_storage_service.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/register_use_case.dart';
import '../features/auth/domain/usecases/login_use_case.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true; // true for Sign In, false for Sign Up
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Profile picture/avatar state
  Uint8List? _selectedProfileBytes;
  String? _selectedPresetAvatarUrl;

  final List<String> _presetAvatars = [
    'https://api.dicebear.com/7.x/bottts/png?seed=Felix&backgroundColor=0f1419,00d9a3',
    'https://api.dicebear.com/7.x/bottts/png?seed=Aneka&backgroundColor=0f1419,ff9500',
    'https://api.dicebear.com/7.x/bottts/png?seed=Jack&backgroundColor=0f1419,0a66c2',
    'https://api.dicebear.com/7.x/bottts/png?seed=Cody&backgroundColor=0f1419,e50914',
    'https://api.dicebear.com/7.x/bottts/png?seed=Buster&backgroundColor=0f1419,7b2cb7',
  ];

  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final RegisterUseCase _registerUseCase;
  late final LoginUseCase _loginUseCase;

  @override
  void initState() {
    super.initState();
    final secureStorageService = SecureStorageService();
    final dioClient = DioClient(secureStorageService);
    final remoteDataSource = AuthRemoteDataSourceImpl(dioClient.dio);
    final repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      secureStorageService: secureStorageService,
    );
    _registerUseCase = RegisterUseCase(repository);
    _loginUseCase = LoginUseCase(repository);
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 24,
                ),
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
                    if (_isSignIn)
                      _buildSignInContent()
                    else
                      _buildSignUpContent(),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
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
            onPressed: _isLoading ? null : _signIn,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
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
              child: Divider(color: Color(0xFF232A3A), thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'or continue with',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
            const Expanded(
              child: Divider(color: Color(0xFF232A3A), thickness: 1),
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

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      _showErrorSnackBar('Please enter your password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _loginUseCase(email: email, password: password);

      if (mounted) {
        currentUser.value = user; // Set current user!
        selectedBottomNavIndex.value = 0; // Reset to Home tab
        isLoggedIn.value = true;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        var errorMsg = e.toString();
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.replaceFirst('Exception: ', '');
        }
        _showErrorSnackBar(errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      _showErrorSnackBar('Please enter your full name');
      return;
    }

    final parts = name.split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : ' ';

    if (email.isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _registerUseCase(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (mounted) {
        userProfileImageBytes.value = _selectedProfileBytes;
        userPresetAvatar.value = _selectedPresetAvatarUrl;
        currentUser.value = user; // Set current user!
        selectedBottomNavIndex.value = 0; // Reset to Home tab
        isLoggedIn.value = true;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        var errorMsg = e.toString();
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.replaceFirst('Exception: ', '');
        }
        _showErrorSnackBar(errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickProfilePicture() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.first.bytes != null) {
        setState(() {
          _selectedProfileBytes = result.files.first.bytes;
          _selectedPresetAvatarUrl = null;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking profile picture: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildSignUpContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Profile Avatar Selection
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10141B),
                      border: Border.all(
                        color: const Color(0xFF00D9A3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D9A3).withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: _selectedProfileBytes != null
                          ? Image.memory(
                              _selectedProfileBytes!,
                              fit: BoxFit.cover,
                            )
                          : _selectedPresetAvatarUrl != null
                              ? Image.network(
                                  _selectedPresetAvatarUrl!,
                                  fit: BoxFit.contain,
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFF6B7687),
                                    size: 40,
                                  ),
                                ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickProfilePicture,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00D9A3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose an avatar or upload photo',
                style: TextStyle(
                  color: Color(0xFF6B7687),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              // Preset Avatar Row
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _presetAvatars.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Custom Upload button
                      return GestureDetector(
                        onTap: _pickProfilePicture,
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF232A3A),
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.upload_rounded,
                            color: Color(0xFF00D9A3),
                            size: 16,
                          ),
                        ),
                      );
                    }
                    final url = _presetAvatars[index - 1];
                    final isSelected = _selectedPresetAvatarUrl == url && _selectedProfileBytes == null;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPresetAvatarUrl = url;
                          _selectedProfileBytes = null;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF00D9A3) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            url,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: const Color(0xFF6B7687),
              ),
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
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
            onPressed: _isLoading ? null : _signUp,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
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
              child: Divider(color: Color(0xFF232A3A), thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'or continue with',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
            const Expanded(
              child: Divider(color: Color(0xFF232A3A), thickness: 1),
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
