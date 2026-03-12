import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';

class BillDetailSkeleton extends StatelessWidget {
  const BillDetailSkeleton({super.key});

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
                    // Subtitle with icon
                    Row(
                      children: [
                        _SkeletonBox(
                          width: 8,
                          height: 8,
                          borderRadius: 4,
                          color: AppColors.secondary.withOpacity(0.3),
                        ),
                        const SizedBox(width: 8),
                        const _SkeletonBox(width: 160, height: 14),
                      ],
                    ),
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
            // ===== Summary section =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  _SkeletonBox(
                    width: 90,
                    height: 24,
                    color: AppColors.onSurface.withOpacity(0.15),
                  ),
                  const SizedBox(height: 16),
                  // Summary text with varying widths
                  const _SkeletonBox(width: double.infinity, height: 14),
                  const SizedBox(height: 10),
                  const _SkeletonBox(width: double.infinity, height: 14),
                  const SizedBox(height: 10),
                  const _SkeletonBox(width: 320, height: 14),
                  const SizedBox(height: 10),
                  const _SkeletonBox(width: 280, height: 14),
                  const SizedBox(height: 10),
                  const _SkeletonBox(width: 200, height: 14),
                  const SizedBox(height: 20),
                  // Action button
                  _SkeletonBox(
                    width: double.infinity,
                    height: 50,
                    borderRadius: 12,
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  // Link
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SkeletonBox(
                          width: 200,
                          height: 14,
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        const SizedBox(width: 6),
                        _SkeletonBox(
                          width: 16,
                          height: 16,
                          borderRadius: 4,
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // ===== Actions section =====
            const _SkeletonSection(
              iconData: Icons.gavel_rounded,
              itemCount: 3,
            ),
            const SizedBox(height: 8),
            // Show more button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SkeletonBox(
                width: double.infinity,
                height: 48,
                borderRadius: 12,
                color: AppColors.primaryContainer.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.outline.withOpacity(0.2), height: 1),
            // ===== Related Bills section =====
            const _SkeletonSection(
              iconData: Icons.description_outlined,
              itemCount: 2,
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.outline.withOpacity(0.2), height: 1),
            // ===== Cosponsors section =====
            const _SkeletonSection(
              iconData: Icons.people_outline_rounded,
              itemCount: 3,
              hasAvatar: true,
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.outline.withOpacity(0.2), height: 1),
            // ===== Amendments section =====
            const _SkeletonSection(
              iconData: Icons.edit_document,
              itemCount: 2,
            ),
            const SizedBox(height: 32),
          ],
        ),
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

class _SkeletonSection extends StatelessWidget {
  final IconData iconData;
  final int itemCount;
  final bool hasAvatar;

  const _SkeletonSection({
    required this.iconData,
    this.itemCount = 3,
    this.hasAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 20,
                color: AppColors.onSurfaceVariant.withOpacity(0.3),
              ),
              const SizedBox(width: 8),
              _SkeletonBox(
                width: 110,
                height: 22,
                color: AppColors.onSurface.withOpacity(0.15),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          itemCount,
          (index) => _SkeletonListItem(
            hasAvatar: hasAvatar,
            isLast: index == itemCount - 1,
          ),
        ),
      ],
    );
  }
}

class _SkeletonListItem extends StatelessWidget {
  final bool hasAvatar;
  final bool isLast;

  const _SkeletonListItem({
    this.hasAvatar = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: isLast ? 0 : 4,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (hasAvatar) ...[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.outline.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person_outline_rounded,
                size: 22,
                color: AppColors.onSurfaceVariant.withOpacity(0.2),
              ),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SkeletonBox(
                      width: hasAvatar ? 140 : 90,
                      height: 12,
                      color: AppColors.onSurfaceVariant.withOpacity(0.2),
                    ),
                    if (!hasAvatar) ...[
                      const SizedBox(width: 12),
                      _SkeletonBox(
                        width: 50,
                        height: 12,
                        color: AppColors.secondary.withOpacity(0.15),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                _SkeletonBox(
                  width: hasAvatar ? 100 : double.infinity,
                  height: hasAvatar ? 12 : 16,
                  color: hasAvatar 
                      ? AppColors.onSurfaceVariant.withOpacity(0.15)
                      : AppColors.onSurface.withOpacity(0.12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.onSurfaceVariant.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
