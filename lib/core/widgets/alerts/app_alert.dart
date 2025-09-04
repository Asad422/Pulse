import 'package:flutter/material.dart';

import '../../theme/text_styles.dart';
import '../../theme/app_colors.dart';
import '../app_button_widget.dart';

enum AppAlertKind { confirm, destructive }

class AppAlerts {
  const AppAlerts._();

  /// Универсальный диалог: возвращает true при подтверждении, false при отмене.
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'OK',
        String cancelText = 'Cancel',
        AppAlertKind kind = AppAlertKind.confirm,
        bool barrierDismissible = true,
      }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => _AppAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        kind: kind,
      ),
    );
    return result ?? false;
  }

  /// Пресет: обычное подтверждение (синяя кнопка).
  static Future<bool> confirm(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'Confirm',
        String cancelText = 'Cancel',
        bool barrierDismissible = true,
      }) =>
      show(
        context,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        kind: AppAlertKind.confirm,
        barrierDismissible: barrierDismissible,
      );

  /// Пресет: деструктивное действие (красная кнопка).
  static Future<bool> destructive(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'Delete',
        String cancelText = 'Cancel',
        bool barrierDismissible = true,
      }) =>
      show(
        context,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        kind: AppAlertKind.destructive,
        barrierDismissible: barrierDismissible,
      );
}

class _AppAlertDialog extends StatelessWidget {
  const _AppAlertDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.kind,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final AppAlertKind kind;

  @override
  Widget build(BuildContext context) {
    final isDestructive = kind == AppAlertKind.destructive;

    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.get("Title/t3")),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.get("Body/p2"),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: AppButtonWidget(
                    label: cancelText,
                    onPressed: () => Navigator.of(context).pop(false),
                    size: AppButtonWidgetSize.medium,
                    intent: AppButtonWidgetIntent.primary,
                    tone: AppButtonWidgetTone.subtle, // «серенькая» вторичная
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButtonWidget(
                    label: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                    size: AppButtonWidgetSize.medium,
                    intent: isDestructive
                        ? AppButtonWidgetIntent.danger
                        : AppButtonWidgetIntent.primary,
                    tone: AppButtonWidgetTone.solid,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
