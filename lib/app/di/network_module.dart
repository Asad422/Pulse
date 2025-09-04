import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class NetworkModule {
  @Named('baseUrl')
  String get baseUrl => 'http://80.76.33.218/api/v1';

  @Named('authDio')
  @lazySingleton
  Dio authDio(@Named('baseUrl') String baseUrl) {
    final d = Dio(BaseOptions(baseUrl: baseUrl));
    d.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        compact: true,
        maxWidth: 120,
      ),
    );
    return d;
  }

  @Named('plainMainDio')
  @lazySingleton
  Dio plainMainDio(@Named('baseUrl') String baseUrl) =>
      Dio(BaseOptions(baseUrl: baseUrl));
}


