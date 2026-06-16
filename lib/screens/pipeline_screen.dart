import 'dart:math';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:file_picker/file_picker.dart';

import '../core/api/dio_client.dart';
import '../core/services/secure_storage_service.dart';
import '../features/interview_session/data/datasources/session_remote_data_source.dart';
import '../features/interview_session/data/repositories/session_repository_impl.dart';
import '../features/interview_session/domain/usecases/create_session_use_case.dart';
import '../core/widgets/user_avatar.dart';


class PipelineScreen extends StatefulWidget {
  const PipelineScreen({super.key});

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  late int _bottomNavIndex;
  
  int _selectedTabIndex = 0; // 0 = Setup, 1 = CV Upload
  String? _selectedRole;
  String? _selectedSeniority;
  String? _selectedCompany;
  PlatformFile? _pickedFile;

  bool _isCreatingSession = false;
  late final CreateSessionUseCase _createSessionUseCase;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = selectedBottomNavIndex.value;
    selectedBottomNavIndex.addListener(_onBottomNavIndexChanged);

    final secureStorageService = SecureStorageService();
    final dioClient = DioClient(secureStorageService);
    final remoteDataSource = SessionRemoteDataSourceImpl(dioClient.dio);
    final repository = SessionRepositoryImpl(remoteDataSource);
    _createSessionUseCase = CreateSessionUseCase(repository);
  }

  String _getCompanyId(String companyName) {
    switch (companyName.toLowerCase()) {
      case 'google':
        return '65f199887766554433221100';
      case 'meta':
        return '65f199887766554433221101';
      case 'amazon':
        return '65f199887766554433221102';
      case 'apple':
        return '65f199887766554433221103';
      case 'netflix':
        return '65f199887766554433221104';
      default:
        return '65f199887766554433221100'; // Default fallback (Google)
    }
  }

  Future<void> _createSession() async {
    if (_selectedRole == null ||
        _selectedSeniority == null ||
        _selectedCompany == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a target role, seniority, and company first.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isCreatingSession = true;
    });

    try {
      final companyId = _getCompanyId(_selectedCompany!);
      await _createSessionUseCase(
        targetRole: _selectedRole!,
        seniorityLevel: _selectedSeniority!,
        targetCompanyId: companyId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Interview session created successfully!'),
            backgroundColor: Color(0xFF00D9A3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        var errorMsg = e.toString();
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.replaceFirst('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create session: $errorMsg'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingSession = false;
        });
      }
    }
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
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: UserAvatar(size: 36),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProgressStep(1, 'CV', true),
                  _buildProgressConnector(),
                  _buildProgressStep(2, 'MCQ', false),
                  _buildProgressConnector(),
                  _buildProgressStep(3, 'HR', false),
                  _buildProgressConnector(),
                  _buildProgressStep(4, 'Tech', false),
                  _buildProgressConnector(),
                  _buildProgressStep(5, 'Final', false),
                ],
              ),
              const SizedBox(height: 32),
              
              // Setup and CV Upload Tabs
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 0 ? const Color(0xFF232A3A) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: _selectedTabIndex == 0 ? null : Border.all(color: const Color(0xFF232A3A)),
                        ),
                        child: Center(
                          child: Text(
                            'Setup',
                            style: TextStyle(
                              color: _selectedTabIndex == 0 ? Colors.white : const Color(0xFF6B7687),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 1 ? const Color(0xFF232A3A) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: _selectedTabIndex == 1 ? null : Border.all(color: const Color(0xFF232A3A)),
                        ),
                        child: Center(
                          child: Text(
                            'CV Upload',
                            style: TextStyle(
                              color: _selectedTabIndex == 1 ? Colors.white : const Color(0xFF6B7687),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Tab Content
              if (_selectedTabIndex == 0) ...[
                // TARGET ROLE
                const Text(
                  'TARGET ROLE',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildRoleChip('Full Stack Engineer'),
                    _buildRoleChip('Frontend'),
                    _buildRoleChip('Backend'),
                    _buildRoleChip('ML Engineer'),
                    _buildRoleChip('DevOps'),
                  ],
                ),
                const SizedBox(height: 32),

                // SENIORITY
                const Text(
                  'SENIORITY',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSeniorityChip('Junior'),
                    _buildSeniorityChip('Mid'),
                    _buildSeniorityChip('Senior'),
                  ],
                ),
                const SizedBox(height: 32),

                // TARGET COMPANY
                const Text(
                  'TARGET COMPANY',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCompanyChip('G', 'Google'),
                    _buildCompanyChip('M', 'Meta'),
                    _buildCompanyChip('A', 'Amazon'),
                    _buildCompanyChip('A', 'Apple'),
                    _buildCompanyChip('N', 'Netflix'),
                  ],
                ),
                const SizedBox(height: 40),

                // Begin Interview Pipeline Button
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
                    onPressed: _isCreatingSession ? null : _createSession,
                    child: _isCreatingSession
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Begin Interview Pipeline',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                const SizedBox(height: 16),
                // Reset Pipeline
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Reset selections
                      setState(() {
                        _selectedRole = null;
                        _selectedSeniority = null;
                        _selectedCompany = null;
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh_outlined, color: Color(0xFF6B7687), size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Reset Pipeline',
                          style: TextStyle(
                            color: Color(0xFF6B7687),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ] else ...[
                // CV Upload tab content
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1F2A36), width: 2, style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF00D9A3), width: 2, style: BorderStyle.solid),
                          ),
                          child: Center(
                            child: _pickedFile == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.upload_outlined, color: Color(0xFF00D9A3), size: 32),
                                      SizedBox(height: 8),
                                      Text(
                                        'Tap to upload your CV',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'PDF, DOC, DOCX · Max 5MB',
                                        style: TextStyle(color: Color(0xFF6B7687)),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.insert_drive_file_outlined, color: Color(0xFF00D9A3), size: 32),
                                      const SizedBox(height: 8),
                                      Text(
                                        _pickedFile!.name,
                                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatBytes(_pickedFile!.size),
                                        style: const TextStyle(color: Color(0xFF6B7687)),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D9A3),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              if (_pickedFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload a CV first')));
                                return;
                              }
                              Navigator.pushNamed(
                                context,
                                '/cv-report',
                                arguments: {
                                  'fileName': _pickedFile!.name,
                                  'fileSize': _pickedFile!.size,
                                },
                              );
                            },
                            child: const Text(
                              'Analyze With AI',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            // Reset uploaded file
                            setState(() {
                              _pickedFile = null;
                            });
                          },
                          child: const Text('Reset Pipeline', style: TextStyle(color: Color(0xFF6B7687))),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
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
              // Already on pipeline/profile
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
            icon: Icon(Icons.show_chart_rounded),
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

  Widget _buildProgressStep(int number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF00D9A3) : const Color(0xFF232A3A),
            border: Border.all(
              color: isActive ? const Color(0xFF00D9A3) : const Color(0xFF232A3A),
            ),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: isActive ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF00D9A3) : const Color(0xFF6B7687),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressConnector() {
    return Expanded(
      child: Container(
        height: 2,
        color: const Color(0xFF232A3A),
        margin: const EdgeInsets.only(top: 18),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = isSelected ? null : role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00D9A3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D9A3) : const Color(0xFF232A3A),
          ),
        ),
        child: Text(
          role,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSeniorityChip(String seniority) {
    final isSelected = _selectedSeniority == seniority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeniority = isSelected ? null : seniority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00D9A3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D9A3) : const Color(0xFF232A3A),
          ),
        ),
        child: Text(
          seniority,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyChip(String initials, String companyName) {
    final isSelected = _selectedCompany == companyName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCompany = isSelected ? null : companyName;
        });
      },
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF00D9A3) : Colors.transparent,
              border: Border.all(
                color: isSelected ? const Color(0xFF00D9A3) : const Color(0xFF232A3A),
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: isSelected
                      ? Colors.black
                      : _getCompanyColor(initials),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            companyName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // File picker for CV upload
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );
      if (!mounted) return;
      if (result == null) return; // user canceled
      final file = result.files.first;
      const maxBytes = 5 * 1024 * 1024; // 5MB
      if (file.size > maxBytes) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File too large. Max size is 5MB')));
        return;
      }
      setState(() {
        _pickedFile = file;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: ${file.name}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (bytes == 0) ? 0 : (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Color _getCompanyColor(String initials) {
    switch (initials) {
      case 'G':
        return const Color(0xFF4285F4); // Google Blue
      case 'M':
        return const Color(0xFF0A66C2); // Meta Blue
      case 'A':
        return const Color(0xFFFF9500); // Amazon Orange
      case 'N':
        return const Color(0xFFE50914); // Netflix Red
      default:
        return const Color(0xFF6B7687);
    }
  }
}

