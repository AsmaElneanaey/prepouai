import '../../domain/entities/credit_transaction.dart';

class CreditTransactionDto {
  const CreditTransactionDto({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    this.stripePaymentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreditTransactionDto.fromJson(Map<String, dynamic> json) {
    return CreditTransactionDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      amount: json['amount'] as int? ?? json['credits'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      stripePaymentId: json['stripe_payment_id'] as String? ?? json['stripePaymentId'] as String?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? json['updatedAt'] as String? ?? '',
    );
  }

  final String id;
  final String userId;
  final int amount;
  final String type;
  final String description;
  final String? stripePaymentId;
  final String createdAt;
  final String updatedAt;

  CreditTransaction toEntity() {
    return CreditTransaction(
      id: id,
      userId: userId,
      amount: amount,
      type: type,
      description: description,
      stripePaymentId: stripePaymentId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
