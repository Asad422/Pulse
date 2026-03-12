enum FailureActionType {
  none,
  logout,
  showSnackbar,
  showDialog,
}

enum FailureDisplayType {
  none,
  fullScreen,
  empty,
}

class Failure {
  final String message;
  final String? debugMessage;
  final FailureActionType action;
  final FailureDisplayType displayType;
  final Object? cause;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.debugMessage,
    this.action = FailureActionType.none,
    this.displayType = FailureDisplayType.none,
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() =>
      'Failure(message: $message, action: $action, display: $displayType'
      '${debugMessage != null ? ', debug: $debugMessage' : ''})';
}
