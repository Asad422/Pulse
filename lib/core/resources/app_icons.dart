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
  static const SvgAsset icLocation = SvgAsset('$_dir/ic_location.svg');

  //NavBar
  static const SvgAsset icLegislations = SvgAsset('$_dir/nav_bar/ic_legislations.svg');
  static const SvgAsset icPoliticians = SvgAsset('$_dir/nav_bar/ic_politicans.svg');
  static const SvgAsset icProfile = SvgAsset('$_dir/nav_bar/ic_profile.svg');
  static const SvgAsset icLaws = SvgAsset('$_dir/nav_bar/ic_laws.svg');

  static const SvgAsset icShare = SvgAsset('$_dir/ic_share.svg');
  static const SvgAsset icLike = SvgAsset('$_dir/ic_like.svg');
  static const SvgAsset icDislike = SvgAsset('$_dir/ic_dislike.svg');

  // Profile
  static const SvgAsset icLanguage = SvgAsset('$_dir/profile/ic_language.svg');
  static const SvgAsset icLogout = SvgAsset('$_dir/profile/ic_logout.svg');
  static const SvgAsset icNotifications = SvgAsset('$_dir/profile/ic_notifications.svg');
  static const SvgAsset icTrash = SvgAsset('$_dir/profile/ic_trash.svg');
  static const SvgAsset icPen = SvgAsset('$_dir/profile/ic_pen.svg');
  static const SvgAsset icArrowRight = SvgAsset('$_dir/profile/ic_arrow_right.svg');



  static const SvgAsset icBookMark = SvgAsset('$_dir/profile/ic_bookmark.svg');

  static const SvgAsset icLink = SvgAsset('$_dir/ic_link.svg');

// static const SvgAsset settings = SvgAsset('$_dir/settings.svg');
}
