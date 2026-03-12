import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connectivity_bloc.dart';
import 'no_internet_screen.dart';

/// Показывает [NoInternetScreen] вместо [child], когда нет интернета.
class ConnectivityGuard extends StatelessWidget {
  const ConnectivityGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      buildWhen: (prev, next) => prev.isConnected != next.isConnected,
      builder: (context, state) {
        if (state.isDisconnected) {
          return const NoInternetScreen();
        }
        return child;
      },
    );
  }
}
