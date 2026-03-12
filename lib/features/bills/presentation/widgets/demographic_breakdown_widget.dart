import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';

class DemographicBreakdownWidget extends StatelessWidget {
  final PollBreakdown breakdown;

  const DemographicBreakdownWidget({
    super.key,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final ageData = Map<String, CategoryBreakdown>.from(breakdown.byAge)
      ..remove('Unknown');
    final locationData = Map<String, CategoryBreakdown>.from(breakdown.byLocation)
      ..remove('Unknown');

    final hasAge = ageData.isNotEmpty;
    final hasLocation = locationData.isNotEmpty;

    if (!hasAge && !hasLocation) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demographic Breakdown',
          style: AppTextStyles.titleT2,
        ),
        const SizedBox(height: 16),
        if (hasAge) ...[
          _SectionHeader(title: 'By Age'),
          const SizedBox(height: 12),
          ...ageData.entries.map((e) => _BreakdownItem(
                label: _formatAgeLabel(e.key),
                data: e.value,
              )),
        ],
        if (hasLocation) ...[
          if (hasAge) const SizedBox(height: 8),
          _SectionHeader(title: 'By Location'),
          const SizedBox(height: 12),
          ...locationData.entries.map((e) => _BreakdownItem(
                label: e.key,
                data: e.value,
              )),
        ],
      ],
    );
  }

  String _formatAgeLabel(String key) {
    if (key.contains('+')) return '$key years';
    if (key.contains('-')) return '$key years';
    return key;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.paragraphP1Bold.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final String label;
  final CategoryBreakdown data;

  const _BreakdownItem({
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final percentFor = data.percentFor;
    final percentAgainst = data.percentAgainst;

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
                    '${percentFor.round()}%',
                    style: AppTextStyles.paragraphP1Bold.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.thumb_up_outlined, size: 16, color: AppColors.green),
                  const SizedBox(width: 12),
                  Text(
                    '${percentAgainst.round()}%',
                    style: AppTextStyles.paragraphP1Bold.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.thumb_down_outlined, size: 16, color: AppColors.error),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          _BreakdownProgressBar(
            percentFor: percentFor,
            percentAgainst: percentAgainst,
          ),
        ],
      ),
    );
  }
}

class _BreakdownProgressBar extends StatelessWidget {
  final double percentFor;
  final double percentAgainst;

  const _BreakdownProgressBar({
    required this.percentFor,
    required this.percentAgainst,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final forWidth = (percentFor / 100) * totalWidth;
        final againstWidth = (percentAgainst / 100) * totalWidth;

        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              if (percentFor > 0)
                Container(
                  width: forWidth.clamp(0, totalWidth),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.horizontal(
                      left: const Radius.circular(4),
                      right: percentAgainst > 0
                          ? Radius.zero
                          : const Radius.circular(4),
                    ),
                  ),
                ),
              if (percentAgainst > 0)
                Container(
                  width: againstWidth.clamp(0, totalWidth - forWidth),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.horizontal(
                      left: percentFor > 0
                          ? Radius.zero
                          : const Radius.circular(4),
                      right: const Radius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
