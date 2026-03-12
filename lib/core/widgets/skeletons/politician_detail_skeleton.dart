import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';

class PoliticianDetailSkeleton extends StatelessWidget {
  const PoliticianDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.surfaceContainerHigh.withOpacity(0.6),
        highlightColor: AppColors.surface.withOpacity(0.9),
        duration: const Duration(milliseconds: 1500),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 128,
              height: 128,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Container(
              width: 200,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            // Position
            Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            // In office
            Container(
              width: 180,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),
            // Vote buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Rating circle
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 150,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 80,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 32),
            Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
            const SizedBox(height: 24),
            // Committee Membership section
            const _SkeletonSection(itemCount: 3),
            const SizedBox(height: 24),
            Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
            const SizedBox(height: 24),
            // Sponsored Bills section
            const _SkeletonSection(itemCount: 3),
            const SizedBox(height: 24),
            Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
            const SizedBox(height: 24),
            // Cosponsored Bills section
            const _SkeletonSection(itemCount: 3),
            const SizedBox(height: 24),
            Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
            const SizedBox(height: 24),
            // Demographic Breakdown section
            const _DemographicBreakdownSkeleton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SkeletonSection extends StatelessWidget {
  final int itemCount;

  const _SkeletonSection({this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Container(
          width: 180,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 12),
        // Info rows
        ...List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DemographicBreakdownSkeleton extends StatelessWidget {
  const _DemographicBreakdownSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(4, (index) => _buildBreakdownItem()),
      ],
    );
  }

  Widget _buildBreakdownItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 18,
                    color: AppColors.onSurfaceVariant.withOpacity(0.2),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
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
