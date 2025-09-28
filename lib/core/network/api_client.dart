import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'auth_interceptor.dart';
import 'token_storage.dart';

/// Клиент API с единым Dio и авторизационным интерцептором
class ApiClient {
  ApiClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    required AuthInterceptor interceptor,
    bool enableLogs = true,
  }) : dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  ) {
    if (enableLogs) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }
    dio.interceptors.add(interceptor);
  }

  final Dio dio;
}
