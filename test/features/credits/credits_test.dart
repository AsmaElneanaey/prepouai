import 'package:flutter_test/flutter_test.dart';
import 'package:prepouai/features/credits/data/models/get_transactions_response_dto.dart';
import 'package:prepouai/features/credits/data/models/purchase_response_dto.dart';
import 'package:prepouai/features/credits/data/repositories/credits_repository_impl.dart';
import 'package:prepouai/features/credits/data/datasources/credits_remote_data_source.dart';
import 'package:prepouai/features/credits/domain/entities/credit_transaction.dart';
import 'package:prepouai/features/credits/domain/usecases/purchase_credits_use_case.dart';
import 'package:prepouai/features/credits/domain/usecases/get_credit_transactions_use_case.dart';

class FakeCreditsRemoteDataSource implements CreditsRemoteDataSource {
  FakeCreditsRemoteDataSource({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<PurchaseResponseDto> purchaseCredits({
    required int amount,
    required String stripePaymentId,
  }) async {
    if (!shouldSucceed) {
      throw Exception('Server error purchasing credits');
    }

    return PurchaseResponseDto.fromJson({
      'success': true,
      'message': 'Credits purchased successfully',
      'data': {
        '_id': 'tx-123',
        'user_id': 'user-456',
        'amount': amount,
        'type': 'purchase',
        'description': 'Purchased $amount credits',
        'stripe_payment_id': stripePaymentId,
        'created_at': '2026-06-16T12:00:00.000Z',
        'updated_at': '2026-06-16T12:00:00.000Z',
      }
    });
  }

  @override
  Future<GetTransactionsResponseDto> getCreditTransactions() async {
    if (!shouldSucceed) {
      throw Exception('Server error fetching credit transactions');
    }

    return GetTransactionsResponseDto.fromJson({
      'success': true,
      'message': 'Credit transactions fetched successfully',
      'data': [
        {
          '_id': 'tx-123',
          'user_id': 'user-456',
          'amount': 50,
          'type': 'purchase',
          'description': 'Purchased 50 credits',
          'stripe_payment_id': 'ch_1HhG3m2eZvKYlo2C7Y',
          'created_at': '2026-06-16T12:00:00.000Z',
          'updated_at': '2026-06-16T12:00:00.000Z',
        },
        {
          '_id': 'tx-124',
          'user_id': 'user-456',
          'amount': -10,
          'type': 'usage',
          'description': 'CV Upload & Parse Stage Usage',
          'created_at': '2026-06-16T10:00:00.000Z',
          'updated_at': '2026-06-16T10:00:00.000Z',
        }
      ]
    });
  }
}

void main() {
  group('Credits Clean Architecture Test Suite', () {
    test('CreditsRepositoryImpl.purchaseCredits maps data to domain correctly', () async {
      final fakeDs = FakeCreditsRemoteDataSource(shouldSucceed: true);
      final repository = CreditsRepositoryImpl(fakeDs);

      final CreditTransaction tx = await repository.purchaseCredits(
        amount: 50,
        stripePaymentId: 'stripe-tx-999',
      );

      expect(tx.id, 'tx-123');
      expect(tx.userId, 'user-456');
      expect(tx.amount, 50);
      expect(tx.type, 'purchase');
      expect(tx.description, 'Purchased 50 credits');
      expect(tx.stripePaymentId, 'stripe-tx-999');
      expect(tx.createdAt, '2026-06-16T12:00:00.000Z');
      expect(tx.updatedAt, '2026-06-16T12:00:00.000Z');
    });

    test('CreditsRepositoryImpl.purchaseCredits forwards errors correctly', () async {
      final fakeDs = FakeCreditsRemoteDataSource(shouldSucceed: false);
      final repository = CreditsRepositoryImpl(fakeDs);

      expect(
        () => repository.purchaseCredits(amount: 50, stripePaymentId: 'stripe-tx-999'),
        throwsException,
      );
    });

    test('CreditsRepositoryImpl.getCreditTransactions maps data to domain list correctly', () async {
      final fakeDs = FakeCreditsRemoteDataSource(shouldSucceed: true);
      final repository = CreditsRepositoryImpl(fakeDs);

      final List<CreditTransaction> txs = await repository.getCreditTransactions();

      expect(txs.length, 2);

      expect(txs[0].id, 'tx-123');
      expect(txs[0].amount, 50);
      expect(txs[0].type, 'purchase');

      expect(txs[1].id, 'tx-124');
      expect(txs[1].amount, -10);
      expect(txs[1].type, 'usage');
    });

    test('CreditsRepositoryImpl.getCreditTransactions forwards errors correctly', () async {
      final fakeDs = FakeCreditsRemoteDataSource(shouldSucceed: false);
      final repository = CreditsRepositoryImpl(fakeDs);

      expect(
        () => repository.getCreditTransactions(),
        throwsException,
      );
    });

    test('PurchaseCreditsUseCase executes command to repository successfully', () async {
      final fakeDs = FakeCreditsRemoteDataSource(shouldSucceed: true);
      final repository = CreditsRepositoryImpl(fakeDs);
      final useCase = PurchaseCreditsUseCase(repository);

      final CreditTransaction tx = await useCase(
        amount: 100,
        stripePaymentId: 'stripe-tx-111',
      );

      expect(tx.amount, 100);
      expect(tx.stripePaymentId, 'stripe-tx-111');
    });

    test('GetCreditTransactionsUseCase executes command to repository successfully', () async {
      final fakeDs = FakeCreditsRemoteDataSource(shouldSucceed: true);
      final repository = CreditsRepositoryImpl(fakeDs);
      final useCase = GetCreditTransactionsUseCase(repository);

      final List<CreditTransaction> txs = await useCase();

      expect(txs.length, 2);
      expect(txs[0].id, 'tx-123');
    });
  });
}
