import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../models/auth_tokens_model.dart';

@lazySingleton
class AuthRemoteDataSource {
  AuthRemoteDataSource(@Named('authDio') this._dio);
  final Dio _dio;

  // /auth/login
  Future<AuthTokensModel> login({required String login, required String password}) async {
    final resp = await _dio.post(
      '/auth/login',
      data: {'login': login, 'password': password},
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
