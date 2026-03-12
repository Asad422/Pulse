import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';

class DemographicBreakdownSkeleton extends StatelessWidget {
  const DemographicBreakdownSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.surfaceContainerHigh.withOpacity(0.6),
        highlightColor: AppColors.surface.withOpacity(0.9),
        duration: const Duration(milliseconds: 1500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demographic Breakdown',
            style: AppTextStyles.titleT2,
          ),
          const SizedBox(height: 16),
          _buildSkeletonItem('18-25'),
          _buildSkeletonItem('26-35'),
          _buildSkeletonItem('36-45'),
          _buildSkeletonItem('46-55'),
        ],
      ),
    );
  }

  Widget _buildSkeletonItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.paragraphP1.copyWith(
                  color: AppColors.onBackground,
                ),
              ),
              Row(
                children: [
                  Text(
                    '50%',
                    style: AppTextStyles.paragraphP1Bold.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
