import 'dart:async';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import 'token_storage.dart';

typedef LogoutCallback = Future<void> Function();

@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor(
      @Named('plainMainDio') this._mainDio,
      @Named('authDio') this._refreshDio,
      this._tokenStorage,
      this._authRepository,
      );

  final Dio _mainDio;        // основной Dio без интерсепторов
  final Dio _refreshDio;     // отдельный Dio для refresh-запросов
  final TokenStorage _tokenStorage;
  final AuthRepository _authRepository;

  Completer<void>? _refreshCompleter;

  bool _isRefreshCall(RequestOptions options) =>
      options.path.contains('/auth/refresh');

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    options.headers.putIfAbsent('Accept', () => 'application/json');
    options.headers.putIfAbsent('Content-Type', () => 'application/json');

    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null &&
        accessToken.isNotEmpty &&
        !_isRefreshCall(options)) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;

    // если это не 401 или это вызов самого refresh -> пропускаем
    if (!is401 || _isRefreshCall(err.requestOptions)) {
      return handler.next(err);
    }

    try {
      // пробуем обновить токен
      await _refreshIfNeeded();
      final newAccess = await _tokenStorage.readAccessToken() ?? '';

      // повторяем оригинальный запрос
      final req = err.requestOptions;
      final opts = Options(
        method: req.method,
        headers: Map<String, dynamic>.from(req.headers)
          ..['Authorization'] = 'Bearer $newAccess',
        responseType: req.responseType,
        sendTimeout: req.sendTimeout,
        receiveTimeout: req.receiveTimeout,
        contentType: req.contentType,
        followRedirects: req.followRedirects,
        validateStatus: req.validateStatus,
        listFormat: req.listFormat,
      );

      final response = await _mainDio.request<dynamic>(
        req.path,
        data: req.data,
        queryParameters: req.queryParameters,
        options: opts,
        cancelToken: req.cancelToken,
        onReceiveProgress: req.onReceiveProgress,
        onSendProgress: req.onSendProgress,
      );

      return handler.resolve(response);
    } catch (_) {
      // refresh не удался → чистим токены
      await _tokenStorage.clear();
      return handler.reject(err);
    }
  }

  Future<void> _refreshIfNeeded() async {
    // если уже есть процесс refresh → ждём его
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<void>();
    try {
      final refreshToken = await _tokenStorage.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw StateError('No refresh token');
      }

      final tokens = await _authRepository.refresh(refreshToken);
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
