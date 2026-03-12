import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/date_formatter.dart';
import 'package:pulse/features/bills/domain/entities/bill_amendment.dart';

class AmendmentItem extends StatelessWidget {
  final BillAmendment amendment;
  const AmendmentItem({super.key, required this.amendment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          // Можно добавить навигацию на детальную страницу amendment
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.formatActionDateTime(amendment.introducedDate),
                    style: AppTextStyles.paragraphP3.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    amendment.title.isNotEmpty ? amendment.title : amendment.congressAmendmentId,
                    style: AppTextStyles.paragraphP2Bold.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  if (amendment.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      amendment.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.paragraphP3.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
