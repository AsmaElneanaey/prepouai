import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/get_transactions_response_dto.dart';
import '../models/purchase_response_dto.dart';

abstract class CreditsRemoteDataSource {
  Future<PurchaseResponseDto> purchaseCredits({
    required int amount,
    required String stripePaymentId,
  });

  Future<GetTransactionsResponseDto> getCreditTransactions();
}

class CreditsRemoteDataSourceImpl implements CreditsRemoteDataSource {
  CreditsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PurchaseResponseDto> purchaseCredits({
    required int amount,
    required String stripePaymentId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.purchaseCredits,
        data: {
          'amount': amount,
          'stripe_payment_id': stripePaymentId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PurchaseResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<GetTransactionsResponseDto> getCreditTransactions() async {
    try {
      final response = await _dio.get(ApiEndpoints.creditTransactions);

      if (response.statusCode == 200) {
        return GetTransactionsResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      final message = _parseErrorMessage(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _parseErrorMessage(DioException e) {
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is List) {
          return message.join(', ');
        } else if (message is String) {
          return message;
        }

        final error = data['error'];
        if (error is Map<String, dynamic> && error['message'] is String) {
          return error['message'] as String;
        }
      }
    }
    return e.message ?? 'An unknown error occurred';
  }
}
