import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

//Обёртка над SVG-иконкой
class SvgAsset {
  final String path;

  const SvgAsset(this.path);

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
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}

class AppIcons {
  AppIcons._();

  static const String _dir = 'assets/icons';

  //Onboarding
  static const SvgAsset icLogo = SvgAsset('$_dir/ic_logo.svg');
  static const SvgAsset icPeoples = SvgAsset('$_dir/ic_peoples.svg');

  //Auth
  static const SvgAsset icApple = SvgAsset('$_dir/ic_apple.svg');
  static const SvgAsset icGoogle = SvgAsset('$_dir/ic_google.svg');
  static const SvgAsset icEye = SvgAsset('$_dir/ic_eye.svg');
  static const SvgAsset icEyeOff = SvgAsset('$_dir/ic_eye_off.svg');

// static const SvgAsset settings = SvgAsset('$_dir/settings.svg');
}
