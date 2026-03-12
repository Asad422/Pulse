import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';

class LawDetailSkeleton extends StatelessWidget {
  const LawDetailSkeleton({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== LegislationVoteCard skeleton =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outline.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge
                    _SkeletonBox(
                      width: 100,
                      height: 28,
                      borderRadius: 14,
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                    const SizedBox(height: 16),
                    // Title lines
                    const _SkeletonBox(width: double.infinity, height: 22),
                    const SizedBox(height: 8),
                    const _SkeletonBox(width: 280, height: 22),
                    const SizedBox(height: 14),
                    // Subtitle
                    const _SkeletonBox(width: 160, height: 14),
                    const SizedBox(height: 8),
                    // Date
                    const _SkeletonBox(width: 140, height: 14),
                    const SizedBox(height: 20),
                    // Vote buttons
                    Row(
                      children: [
                        Expanded(
                          child: _SkeletonBox(
                            width: double.infinity,
                            height: 48,
                            borderRadius: 12,
                            color: AppColors.primaryContainer.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SkeletonBox(
                            width: double.infinity,
                            height: 48,
                            borderRadius: 12,
                            color: AppColors.errorContainer.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Vote progress bar
                    _SkeletonBox(
                      width: double.infinity,
                      height: 6,
                      borderRadius: 3,
                      color: AppColors.surfaceContainerHigh,
                    ),
                    const SizedBox(height: 10),
                    // Votes count
                    const Center(child: _SkeletonBox(width: 80, height: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: AppColors.outline.withOpacity(0.2), height: 1),
            const SizedBox(height: 20),
            // ===== Details section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  _SkeletonBox(
                    width: 70,
                    height: 24,
                    color: AppColors.onSurface.withOpacity(0.15),
                  ),
                  const SizedBox(height: 16),
                  // Info rows
                  _buildInfoRow(100, 50),
                  _buildInfoRow(100, 80),
                  _buildInfoRow(100, 60),
                  _buildInfoRow(100, 90),
                  const SizedBox(height: 12),
                  // Link
                  _SkeletonBox(
                    width: 150,
                    height: 14,
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Divider(color: AppColors.outline.withOpacity(0.2), height: 1),
            const SizedBox(height: 24),
            // ===== Related Bills section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SkeletonBox(
                width: 120,
                height: 24,
                color: AppColors.onSurface.withOpacity(0.15),
              ),
            ),
            const SizedBox(height: 16),
            _buildRelatedBillItem(),
            _buildRelatedBillItem(),
            const SizedBox(height: 24),
            Divider(color: AppColors.outline.withOpacity(0.2), height: 1),
            const SizedBox(height: 24),
            // ===== Demographic Breakdown section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(
                    width: 200,
                    height: 24,
                    color: AppColors.onSurface.withOpacity(0.15),
                  ),
                  const SizedBox(height: 20),
                  _buildBreakdownItem(),
                  _buildBreakdownItem(),
                  _buildBreakdownItem(),
                  _buildBreakdownItem(),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(double labelWidth, double valueWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _SkeletonBox(
            width: labelWidth,
            height: 14,
            color: AppColors.onSurfaceVariant.withOpacity(0.2),
          ),
          const SizedBox(width: 20),
          _SkeletonBox(
            width: valueWidth,
            height: 14,
            color: AppColors.onSurface.withOpacity(0.15),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedBillItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                const _SkeletonBox(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                _SkeletonBox(
                  width: 80,
                  height: 12,
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.onSurfaceVariant.withOpacity(0.2),
          ),
        ],
      ),
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
              const _SkeletonBox(width: 60, height: 16),
              Row(
                children: [
                  const _SkeletonBox(width: 40, height: 16),
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
          _SkeletonBox(
            width: double.infinity,
            height: 8,
            borderRadius: 4,
            color: AppColors.surfaceContainerLow,
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
