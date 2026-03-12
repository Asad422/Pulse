import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import 'connectivity_bloc.dart';

/// Полноэкранный экран "Нет интернета". Показывается вместо контента при отсутствии сети.
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize:  MainAxisSize.max,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: AppColors.onSurfaceVariant.withOpacity(0.6),
              ),
              const SizedBox(height: 24),
              Text(
                'No internet connection',
                style: AppTextStyles.titleT2.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Check your connection and try again.',
                style: AppTextStyles.paragraphP2.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  context.read<ConnectivityBloc>().add(ConnectivityCheckRequested());
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
