import 'package:dio/dio.dart';
import '../services/secure_storage_service.dart';
import 'api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

class DioClient {
  DioClient(SecureStorageService secureStorageService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(AuthInterceptor(secureStorageService));
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
