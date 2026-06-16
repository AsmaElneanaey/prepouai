import 'package:flutter/material.dart';
import '../core/api/dio_client.dart';
import '../core/services/secure_storage_service.dart';
import '../features/interview_session/domain/entities/interview_session.dart';
import '../features/interview_session/domain/usecases/get_user_sessions_use_case.dart';
import '../features/interview_session/data/datasources/session_remote_data_source.dart';
import '../features/interview_session/data/repositories/session_repository_impl.dart';

class InterviewListSection extends StatefulWidget {
  const InterviewListSection({super.key});

  @override
  State<InterviewListSection> createState() => _InterviewListSectionState();
}

class _InterviewListSectionState extends State<InterviewListSection> {
  late final GetUserSessionsUseCase _getUserSessionsUseCase;
  Future<List<InterviewSession>>? _sessionsFuture;

  @override
  void initState() {
    super.initState();
    final secureStorageService = SecureStorageService();
    final dioClient = DioClient(secureStorageService);
    final remoteDataSource = SessionRemoteDataSourceImpl(dioClient.dio);
    final repository = SessionRepositoryImpl(remoteDataSource);
    _getUserSessionsUseCase = GetUserSessionsUseCase(repository);

    _sessionsFuture = _getUserSessionsUseCase();
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (_) {
      return 'Recent';
    }
  }

  String _getStatusLabel(InterviewSession session) {
    return session.status.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENT INTERVIEWS',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _sessionsFuture = _getUserSessionsUseCase();
                });
              },
              child: const Row(
                children: [
                  Icon(Icons.refresh_rounded, color: Colors.grey, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Refresh',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<InterviewSession>>(
          future: _sessionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator(
                    color: Color(0xFF00D9A3),
                    strokeWidth: 2.5,
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2A3142)),
                ),
                child: Text(
                  'Error loading sessions: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              );
            }

            final sessions = snapshot.data ?? [];
            if (sessions.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2A3142)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.history_rounded, color: Colors.grey, size: 28),
                    SizedBox(height: 8),
                    Text(
                      'No interviews scheduled yet. Begin one today!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: sessions.map((session) {
                final dateLabel = _formatDate(
                  session.startedAt.isNotEmpty
                      ? session.startedAt
                      : session.createdAt,
                );
                final statusLabel = _getStatusLabel(session);
                return _buildInterviewItem(
                  session.title,
                  dateLabel,
                  statusLabel,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInterviewItem(String title, String date, String score) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A3142)),
      ),
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.code, color: Color(0xFF00D9A3), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00D9A3).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              score,
              style: const TextStyle(
                color: Color(0xFF00D9A3),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        ],
      ),
    );
  }
}
