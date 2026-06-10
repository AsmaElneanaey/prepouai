import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/register_request_dto.dart';
import '../models/register_response_dto.dart';
import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseDto> register(RegisterRequestDto request);
  Future<LoginResponseDto> login(LoginRequestDto request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<RegisterResponseDto> register(RegisterRequestDto request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return RegisterResponseDto.fromJson(response.data as Map<String, dynamic>);
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
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseDto.fromJson(response.data as Map<String, dynamic>);
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
      }
    }
    return e.message ?? 'An unknown error occurred';
  }
}
