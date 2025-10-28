// lib/app/di/network_module.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/network/auth_interceptor.dart';

@module
abstract class NetworkModule {
  @Named('baseUrl')
  String get baseUrl => 'http://144.217.165.214/api/v1';

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
    return dio;
  }
}
