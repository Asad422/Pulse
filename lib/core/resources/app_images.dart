import 'package:flutter/widgets.dart';

/// Обёртка над растровой картинкой (png/jpg/webp)
class RasterAsset {
  final String path;
  const RasterAsset(this.path);

  Image image({
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    FilterQuality filterQuality = FilterQuality.medium,
  }) {
    return Image.asset(
      path,
      key: key,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
    );
  }

  /// Удобно для DecorationImage, ImageProvider и т.п.
  AssetImage provider() => AssetImage(path);
}

class AppImages {
  AppImages._();
  // static const String _img = 'assets/images';
  // static const String _ill = 'assets/illustrations';

// Добавляй дальше по проекту:
// static const RasterAsset banner = RasterAsset('$_img/banner.webp');
}
