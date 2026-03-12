import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

import '../state/app_state.dart';
import '../failure/failure.dart';

class FailureBlocObserver extends BlocObserver {
  FailureBlocObserver({
    required this.navigatorKey,
    this.onLogout,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Future<void> Function()? onLogout;

  /// Prevents the same failure object from triggering the handler twice
  /// (e.g. when other state fields change but the failure stays the same).
  Failure? _lastHandledFailure;

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    final state = transition.nextState;
    if (state is AppState &&
        state.failure != null &&
        !identical(state.failure, _lastHandledFailure)) {
      _lastHandledFailure = state.failure;
      _logFailure(bloc, state.failure!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleFailure(state.failure!);
      });
    }
  }

  void _handleFailure(Failure failure) {
    if (failure.displayType == FailureDisplayType.fullScreen) return;
    if (failure.displayType == FailureDisplayType.empty) return;

    switch (failure.action) {
      case FailureActionType.logout:
        _showToast(failure.message);
        onLogout?.call();
        break;
      case FailureActionType.showSnackbar:
      case FailureActionType.showDialog:
        _showToast(failure.message);
        break;
      case FailureActionType.none:
        break;
    }
  }

  void _showToast(String message) {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      ToastService.showErrorToast(
        context,
        message: message,
        length: ToastLength.medium,
      );
    }
  }

  void _logFailure(Bloc bloc, Failure failure) {
    debugPrint(
      '[${bloc.runtimeType}] ${failure.runtimeType}: ${failure.message}'
      '${failure.debugMessage != null ? ' | debug: ${failure.debugMessage}' : ''}',
    );
    if (failure.stackTrace != null) {
      debugPrintStack(stackTrace: failure.stackTrace!, label: 'Failure origin');
    }
  }
}
