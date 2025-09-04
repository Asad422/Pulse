import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/core/widgets/trending_politicians_carousel/image_with_progress_bar_widget.dart';

class PoliticianCarouselCardWidget extends StatelessWidget {
  const PoliticianCarouselCardWidget({
    super.key,
    required this.name,
    required this.party, // 'D', 'R', etc.
    required this.state, // 'California'
    required this.rating, // 0..100
    required this.imageUrl,
    required this.onRate,
  });

  final String name;
  final String party;
  final String state;
  final double rating;
  final String imageUrl;
  final VoidCallback onRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144,
      height: 204,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ImageWithProgressBarWidget(
              imageUrl: imageUrl,
              rating: rating,
            ),
          ),
          const SizedBox(height: 12),

          // Имя
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.get("Body/p3-bold"),
          ),
          const SizedBox(height: 4),

          // Партия—Штат
          Text(
            '$party-$state',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.get("Body/p3"),
          ),
          const Spacer(),

          // Кнопка Rate
          SizedBox(
            width: double.infinity,
            child: AppButtonWidget(
              label: 'Rate',
              onPressed: onRate,
              tone: AppButtonWidgetTone.subtle,
              size: AppButtonWidgetSize.small,
              borderRadius: 8,
            ),
          ),
        ],
      ),
    );
  }
}
