import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/features/politicians/domain/entities/politican_detail.dart';

class CommitteeMembershipItem extends StatelessWidget {
  final Membership membership;
  const CommitteeMembershipItem({super.key, required this.membership});

  @override
  Widget build(BuildContext context) {
    final dateInfo = membership.endDate != null
        ? '${membership.startDate} - ${membership.endDate}'
        : '${membership.startDate} - Present';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.groups_outlined,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  membership.organization,
                  style: AppTextStyles.paragraphP2Bold.copyWith(
                    color: AppColors.onBackground,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (membership.role.isNotEmpty) ...[
                      Flexible(
                        child: Text(
                          membership.role,
                          style: AppTextStyles.paragraphP3.copyWith(
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      dateInfo,
                      style: AppTextStyles.paragraphP3.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
