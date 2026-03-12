import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/router/routes.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/utils/date_formatter.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';

class PoliticianBillItem extends StatelessWidget {
  final Bill bill;
  final bool isCosponsored;
  
  const PoliticianBillItem({
    super.key, 
    required this.bill,
    this.isCosponsored = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRoutes.billDetail,
            pathParameters: {'id': bill.id.toString()},
          );
        },
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
              child: Icon(
                isCosponsored ? Icons.edit_outlined : Icons.description_outlined,
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
                    bill.title,
                    style: AppTextStyles.paragraphP2Bold.copyWith(
                      color: AppColors.onBackground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        bill.congressBillId.toUpperCase(),
                        style: AppTextStyles.paragraphP3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormatter.formatActionDateTime(bill.introducedDate),
                        style: AppTextStyles.paragraphP3.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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
