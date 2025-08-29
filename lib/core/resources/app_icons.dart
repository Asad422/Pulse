import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Обёртка над SVG-иконкой
class SvgAsset {
  final String path;

  const SvgAsset(this.path);

  /// Быстрый билдер иконки
  SvgPicture svg({
    Key? key,
    double? size,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    String? semanticsLabel,
  }) {
    return SvgPicture.asset(
      path,
      key: key,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
      semanticsLabel: semanticsLabel,
      // flutter_svg 2.x: цвет прокидывается через colorFilter
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}

class AppIcons {
  AppIcons._();

  static const String _dir = 'assets/icons';

  static const SvgAsset icLogo = SvgAsset('$_dir/ic_logo.svg');
  static const SvgAsset icPeoples = SvgAsset('$_dir/ic_peoples.svg');

// Добавляй свои по мере надобности ↓
// static const SvgAsset settings = SvgAsset('$_dir/settings.svg');
}
