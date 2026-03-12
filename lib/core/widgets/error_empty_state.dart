import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

/// Экран «No data found» при ошибке сервера (500) или сети.
/// Показывает иконку зачёркнутого облака и кнопку Retry.
class ErrorEmptyState extends StatelessWidget {
  const ErrorEmptyState({
    super.key,
    this.title = 'No data found',
    this.subtitle = 'Something went wrong. Please try again later.',
    this.onRetry,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 64,
                  color: AppColors.onSurfaceVariant.withOpacity(0.5),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(
                    Icons.close_rounded,
                    size: 28,
                    color: AppColors.error.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.titleT2.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: AppTextStyles.paragraphP2.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
