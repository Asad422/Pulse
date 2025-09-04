import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../core/network/auth_interceptor.dart';

@module
abstract class InterceptorModule {
  @lazySingleton
  Dio configuredMainDio(
      @Named('plainMainDio') Dio dio,
      AuthInterceptor interceptor,
      ) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: true,
        maxWidth: 120,
      ),
    );
    dio.interceptors.add(interceptor);
    return dio; // это и будет дефолтный Dio
  }
}
