import '../entities/credit_transaction.dart';

abstract class CreditsRepository {
  Future<CreditTransaction> purchaseCredits({
    required int amount,
    required String stripePaymentId,
  });

  Future<List<CreditTransaction>> getCreditTransactions();
}
