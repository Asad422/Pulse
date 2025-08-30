import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

enum PromiseStatus { kept, broken, pending }

class PromiseCard extends StatelessWidget {
  const PromiseCard({
    super.key,
    required this.title,
    required this.dateText,
    required this.body,
    required this.status,
    this.statusText,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String dateText;
  final String body;
  final PromiseStatus status;
  final String? statusText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (fg, bg, defaultLabel) = _statusColors(status);

    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerLow),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.titleT3),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(subtitle!, style: AppTextStyles.paragraphP2High),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(dateText, style: AppTextStyles.paragraphP2High),
                ],
              ),
              const SizedBox(height: 8),
              Text(body, style: AppTextStyles.paragraphP2),
              const SizedBox(height: 12),
              _StatusChip(
                text: statusText ?? defaultLabel,
                fg: fg,
                bg: bg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color fg, Color bg, String label) _statusColors(PromiseStatus s) {
    switch (s) {
      case PromiseStatus.kept:
        return (AppColors.green, AppColors.greenContainer, 'Kept');
      case PromiseStatus.broken:
        return (AppColors.error, AppColors.errorContainer, 'Broken');
      case PromiseStatus.pending:
        return (AppColors.yellow, AppColors.yellowContainer, 'Pending');
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.text,
    required this.fg,
    required this.bg,
  });

  final String text;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelL3.copyWith(color: fg),
      ),
    );
  }
}
