import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../features/auth/domain/entities/user.dart';
import '../core/api/dio_client.dart';
import '../core/services/secure_storage_service.dart';
import '../core/api/api_endpoints.dart';

class CreditsSection extends StatefulWidget {
  const CreditsSection({super.key});

  @override
  State<CreditsSection> createState() => _CreditsSectionState();
}

class _CreditsSectionState extends State<CreditsSection> {
  bool _isLoading = false;

  Future<void> _purchaseCredits() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final secureStorageService = SecureStorageService();
      final dioClient = DioClient(secureStorageService);
      
      final response = await dioClient.dio.post(
        ApiEndpoints.purchaseCredits,
        data: {
          'amount': 100,
          'stripe_payment_id': 'mock-stripe-${DateTime.now().millisecondsSinceEpoch}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully upgraded! 100 AI Credits added.'),
              backgroundColor: Color(0xFF00D9A3),
            ),
          );
        }
        await refreshUserProfile();
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        var errorMsg = e.toString();
        if (errorMsg.startsWith('Exception: ')) {
          errorMsg = errorMsg.replaceFirst('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to purchase credits: $errorMsg'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A3142)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<User?>(
            valueListenable: currentUser,
            builder: (context, user, _) {
              final credits = user?.totalCredits ?? 50;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Credits',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$credits remaining',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              );
            },
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _purchaseCredits,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9A3),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Upgrade',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}


