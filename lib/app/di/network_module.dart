// lib/app/di/network_module.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/network/auth_interceptor.dart';

@module
abstract class NetworkModule {
  @Named('baseUrl')
  String get baseUrl =>
      dotenv.get('BASE_URL', fallback: 'http://144.217.165.214/api/v1');

  /// Dio без интерсепторов — для refresh/login
  @Named('plainMainDio')
  @lazySingleton
  Dio plainMainDio(@Named('baseUrl') String baseUrl) {
    return Dio(BaseOptions(baseUrl: baseUrl));
  }

  /// Dio с AuthInterceptor — для всех защищённых API
  @Named('authDio')
  @lazySingleton
  Dio authDio(
      @Named('baseUrl') String baseUrl,
      AuthInterceptor interceptor,
      ) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.add(interceptor);
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false, // не логировать Authorization и другие заголовки
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }
    return dio;
  }
}
