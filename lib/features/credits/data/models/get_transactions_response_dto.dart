import 'credit_transaction_dto.dart';

class GetTransactionsResponseDto {
  const GetTransactionsResponseDto({
    required this.success,
    required this.message,
    required this.transactions,
  });

  factory GetTransactionsResponseDto.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List? ?? [];
    final transactions = list
        .map((item) => CreditTransactionDto.fromJson(item as Map<String, dynamic>))
        .toList();

    return GetTransactionsResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      transactions: transactions,
    );
  }

  final bool success;
  final String message;
  final List<CreditTransactionDto> transactions;
}
