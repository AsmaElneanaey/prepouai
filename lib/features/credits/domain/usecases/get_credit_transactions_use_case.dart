import '../entities/credit_transaction.dart';
import '../repositories/credits_repository.dart';

class GetCreditTransactionsUseCase {
  GetCreditTransactionsUseCase(this._repository);

  final CreditsRepository _repository;

  Future<List<CreditTransaction>> call() {
    return _repository.getCreditTransactions();
  }
}
