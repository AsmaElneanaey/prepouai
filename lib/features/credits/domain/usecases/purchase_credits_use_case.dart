import '../entities/credit_transaction.dart';
import '../repositories/credits_repository.dart';

class PurchaseCreditsUseCase {
  PurchaseCreditsUseCase(this._repository);

  final CreditsRepository _repository;

  Future<CreditTransaction> call({
    required int amount,
    required String stripePaymentId,
  }) {
    return _repository.purchaseCredits(
      amount: amount,
      stripePaymentId: stripePaymentId,
    );
  }
}
