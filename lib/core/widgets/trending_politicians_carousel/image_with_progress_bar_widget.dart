import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/widgets/network_avatar.dart';
import 'package:pulse/core/widgets/trending_politicians_carousel/circular_progress_bar_widget.dart';

class ImageWithProgressBarWidget extends StatefulWidget {
  final String imageUrl;
  final double rating;

  const ImageWithProgressBarWidget({
    super.key,
    required this.imageUrl,
    required this.rating,
  });

  @override
  State<ImageWithProgressBarWidget> createState() =>
      _ImageWithProgressBarWidgetState();
}

class _ImageWithProgressBarWidgetState
    extends State<ImageWithProgressBarWidget> {


  Color _ratingColor(double p) {
    if (p >= 70) return AppColors.green;
    if (p >= 30) return AppColors.yellow;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: 88,
          width: 88,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.center,
                child: NetworkAvatar(
                  url: widget.imageUrl,
                  size: 88,
                ),
              ),
              // прогресс индикатор в правом нижнем углу аватара
              Positioned(
                right: 0,
                bottom: 0,
                child: CircularProgressBarWidget(
                  fontSize: 10,
                  lineHeight: 12,
                  percent: widget.rating / 100.0,
                  size: 36,
               
                ),
              ),
            ],
          ),
        );
  }
}
