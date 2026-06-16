import '../../domain/entities/credit_transaction.dart';
import '../../domain/repositories/credits_repository.dart';
import '../datasources/credits_remote_data_source.dart';

class CreditsRepositoryImpl implements CreditsRepository {
  CreditsRepositoryImpl(this._remoteDataSource);

  final CreditsRemoteDataSource _remoteDataSource;

  @override
  Future<CreditTransaction> purchaseCredits({
    required int amount,
    required String stripePaymentId,
  }) async {
    final response = await _remoteDataSource.purchaseCredits(
      amount: amount,
      stripePaymentId: stripePaymentId,
    );
    return response.transaction.toEntity();
  }

  @override
  Future<List<CreditTransaction>> getCreditTransactions() async {
    final response = await _remoteDataSource.getCreditTransactions();
    return response.transactions.map((dto) => dto.toEntity()).toList();
  }
}
