import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/failure/failures.dart';

/// Wraps an async [call] into Either, mapping any thrown exception to [Failure].
/// Eliminates repetitive try/catch blocks in repositories.
Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } catch (e, s) {
    return Left(mapFailure(e, s));
  }
}

Failure mapFailure(Object error, [StackTrace? stackTrace]) {
  if (error is DioException) return _mapDioException(error, stackTrace);
  return ValidationFailure(
    error.toString(),
    cause: error,
    stackTrace: stackTrace,
  );
}

Failure _mapDioException(DioException e, [StackTrace? stackTrace]) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError) {
    return NetworkFailure(
      'Network error. Check your connection.',
      debugMessage: e.message,
      cause: e,
      stackTrace: stackTrace,
    );
  }

  final status = e.response?.statusCode;
  final rawMessage = _parseMessage(e.response?.data);

  switch (status) {
    case 400:
      // Validation errors — show the backend message (useful for the user)
      return ValidationFailure(
        rawMessage,
        debugMessage: rawMessage,
        cause: e,
        stackTrace: stackTrace,
      );
    case 401:
      return UnauthorizedFailure(
        'Your session has expired. Please log in again.',
        debugMessage: rawMessage,
        cause: e,
        stackTrace: stackTrace,
      );
    case 403:
      return ForbiddenFailure(
        'You don\'t have permission for this action.',
        debugMessage: rawMessage,
        cause: e,
        stackTrace: stackTrace,
      );
    case 404:
      return NotFoundFailure(
        'The requested item was not found.',
        debugMessage: rawMessage,
        cause: e,
        stackTrace: stackTrace,
      );
    case 500:
    case 502:
    case 503:
      return ServerFailure(
        'Server error. Please try again later.',
        debugMessage: rawMessage,
        cause: e,
        stackTrace: stackTrace,
      );
    default:
      if (status != null && status >= 500) {
        return ServerFailure(
          'Server error. Please try again later.',
          debugMessage: rawMessage,
          cause: e,
          stackTrace: stackTrace,
        );
      }
      return NetworkFailure(
        'Something went wrong. Please try again.',
        debugMessage: rawMessage,
        cause: e,
        stackTrace: stackTrace,
      );
  }
}

String _parseMessage(dynamic data) {
  if (data == null) return 'Something went wrong';
  if (data is String) {
    if (_looksLikeHtml(data)) return 'Something went wrong';
    return data;
  }
  if (data is Map<String, dynamic>) {
    final detail = data['detail'];
    if (detail is String) return detail;
    if (detail is List) {
      final messages = <String>[];
      for (final item in detail) {
        if (item is Map<String, dynamic>) {
          final msg = item['msg'] as String?;
          if (msg != null && msg.isNotEmpty) messages.add(msg);
        }
      }
      if (messages.isNotEmpty) return messages.join('. ');
    }
    return data['message'] as String? ??
        data['error'] as String? ??
        'Something went wrong';
  }
  return data.toString();
}

bool _looksLikeHtml(String text) {
  final trimmed = text.trimLeft();
  return trimmed.startsWith('<!') ||
      trimmed.startsWith('<html') ||
      trimmed.startsWith('<HTML');
}
