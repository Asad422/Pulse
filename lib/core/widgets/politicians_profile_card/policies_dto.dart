import 'dart:ui';

import 'package:pulse/core/theme/app_colors.dart';

/// Модель для правых цветных «чипов» в списке инициатив
class PolicyTag {
  const PolicyTag({
    required this.title,
    required this.label,
    required this.bg,
    required this.fg,
  });

  /// Быстрые пресеты под макет
  factory PolicyTag.green(String title) => PolicyTag(
        title: title,
        label: 'Green',
        bg: AppColors.greenContainer,
        fg: AppColors.onGreenContainer,
      );

  factory PolicyTag.blue(String title) => PolicyTag(
        title: title,
        label: 'Blue',
        bg: AppColors.secondaryContainer,
        fg: AppColors.onSecondaryContainer,
      );

  factory PolicyTag.red(String title) => PolicyTag(
        title: title,
        label: 'Red',
        bg: AppColors.errorContainer,
        fg: AppColors.onErrorContainer,
      );

  final String title; // «Climate Action Plan»
  final String label; // «Green»
  final Color bg;
  final Color fg;
}