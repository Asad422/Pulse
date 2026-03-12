import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/router/routes.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/features/bills/domain/entities/related_bill.dart';

class RelatedBillItem extends StatelessWidget {
  final RelatedBill relatedBill;
  const RelatedBillItem({super.key, required this.relatedBill});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRoutes.billDetail,
            pathParameters: {'id': relatedBill.relatedBillId.toString()},
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Introduced: ${relatedBill.relatedBillIntroducedDate}',
                        style: AppTextStyles.paragraphP3.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${relatedBill.relatedBillTitle} ${relatedBill.type} ${relatedBill.number}",
                          style: AppTextStyles.paragraphP2Bold.copyWith(
                            color: AppColors.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
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
