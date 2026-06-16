import 'credit_transaction_dto.dart';

class PurchaseResponseDto {
  const PurchaseResponseDto({
    required this.success,
    required this.message,
    required this.transaction,
  });

  factory PurchaseResponseDto.fromJson(Map<String, dynamic> json) {
    return PurchaseResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      transaction: CreditTransactionDto.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  final bool success;
  final String message;
  final CreditTransactionDto transaction;
}
