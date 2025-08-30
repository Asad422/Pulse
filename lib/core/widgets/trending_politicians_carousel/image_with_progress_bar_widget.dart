import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
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
    return // Аватар + прогресс индикатор
        SizedBox(
          height: 88,
          width: 88,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // фон-диск под аватаром
              Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.network(
                    widget.imageUrl,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // прогресс индикатор в правом нижнем углу аватара
              Positioned(
                right: 0,
                bottom: 0,
                child: CircularProgressBarWidget(
                  percent: widget.rating / 100.0,
                  size: 36,
                  fillColor:
                      _ratingColor(widget.rating), //_ratingColor отвечает за цвет
                ),
              ),
            ],
          ),
        );
  }
}
