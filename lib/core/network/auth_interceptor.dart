import 'dart:async';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../auth/auth_notifier.dart';
import 'token_storage.dart';
import '../../features/auth/data/models/auth_tokens_model.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    @Named('plainMainDio') this._plainDio,
    this._tokenStorage,
    this._authNotifier,
  );

  final Dio _plainDio;
  final TokenStorage _tokenStorage;
  final AuthNotifier _authNotifier;

  Completer<void>? _refreshCompleter;

  bool _isRefreshCall(RequestOptions options) =>
      options.path.contains('/auth/refresh');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.putIfAbsent('Accept', () => 'application/json');
    options.headers.putIfAbsent('Content-Type', () => 'application/json');

    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty && !_isRefreshCall(options)) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 || _isRefreshCall(err.requestOptions)) {
      return handler.next(err);
    }

    try {
      await _refreshIfNeeded();
      final newAccess = await _tokenStorage.readAccessToken() ?? '';

      final req = err.requestOptions;
      final opts = Options(
        method: req.method,
        headers: Map<String, dynamic>.from(req.headers)
          ..['Authorization'] = 'Bearer $newAccess',
        responseType: req.responseType,
        contentType: req.contentType,
      );

      final response = await _plainDio.request<dynamic>(
        req.path,
        data: req.data,
        queryParameters: req.queryParameters,
        options: opts,
      );

      return handler.resolve(response);
    } catch (_) {
      await _tokenStorage.clear();
      _authNotifier.setLoggedOut();
      return handler.reject(err);
    }
  }

  Future<void> _refreshIfNeeded() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<void>();
    try {
      final refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw StateError('No refresh token');
      }

      final resp = await _plainDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(contentType: Headers.jsonContentType),
      );

      final tokens = AuthTokensModel.fromJson(resp.data as Map<String, dynamic>);
      await _tokenStorage.writeTokens(tokens);

      _refreshCompleter!.complete();
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }
}
