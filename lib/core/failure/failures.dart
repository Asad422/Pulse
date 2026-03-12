import 'failure.dart';

class ValidationFailure extends Failure {
  const ValidationFailure(
    String message, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          debugMessage: debugMessage,
          action: FailureActionType.showSnackbar,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
    String message, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          debugMessage: debugMessage,
          action: FailureActionType.logout,
          displayType: FailureDisplayType.none,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(
    String message, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          debugMessage: debugMessage,
          action: FailureActionType.showSnackbar,
          displayType: FailureDisplayType.none,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(
    String message, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          debugMessage: debugMessage,
          action: FailureActionType.none,
          displayType: FailureDisplayType.empty,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class ServerFailure extends Failure {
  const ServerFailure(
    String message, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          debugMessage: debugMessage,
          action: FailureActionType.none,
          displayType: FailureDisplayType.fullScreen,
          cause: cause,
          stackTrace: stackTrace,
        );
}

class NetworkFailure extends Failure {
  const NetworkFailure(
    String message, {
    String? debugMessage,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          debugMessage: debugMessage,
          action: FailureActionType.none,
          displayType: FailureDisplayType.fullScreen,
          cause: cause,
          stackTrace: stackTrace,
        );
}
