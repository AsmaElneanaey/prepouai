import 'package:equatable/equatable.dart';

class CreditTransaction extends Equatable {
  const CreditTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    this.stripePaymentId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final int amount;
  final String type;
  final String description;
  final String? stripePaymentId;
  final String createdAt;
  final String updatedAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        amount,
        type,
        description,
        stripePaymentId,
        createdAt,
        updatedAt,
      ];
}
