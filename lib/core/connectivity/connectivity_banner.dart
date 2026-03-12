import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import 'connectivity_bloc.dart';

/// Баннер "Нет подключения к интернету" поверх контента
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      buildWhen: (prev, next) => prev.isConnected != next.isConnected,
      builder: (context, state) {
        return Stack(
          children: [
            child,
            if (state.isDisconnected)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: AppColors.error,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No internet connection',
                              style: AppTextStyles.paragraphP2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
