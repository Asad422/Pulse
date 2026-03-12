import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../models/auth_tokens_model.dart';

@lazySingleton
class AuthRemoteDataSource {
  AuthRemoteDataSource(@Named('authDio') this._dio);
  final Dio _dio;

  // /auth/otp/request
  Future<void> requestOtp({required String email, required String login}) async {
    await _dio.post(
      '/auth/otp/request',
      data: {'email': email, 'login': login},
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  // /auth/otp/verify
  Future<AuthTokensModel> verifyOtp({
    required String email,
    required String code,
  }) async {
    final resp = await _dio.post(
      '/auth/otp/verify',
      data: {'email': email, 'code': code},
      options: Options(contentType: Headers.jsonContentType),
    );
    return AuthTokensModel.fromJson(resp.data as Map<String, dynamic>);
  }

  // /auth/refresh
  Future<AuthTokensModel> refresh(String refreshToken) async {
    final resp = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
      options: Options(contentType: Headers.jsonContentType),
    );
    return AuthTokensModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
