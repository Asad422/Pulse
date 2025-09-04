import 'package:flutter/material.dart';
import 'package:pulse/core/resources/app_icons.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/core/widgets/politicians_profile_card/politician_dto.dart';
import 'package:pulse/core/widgets/trending_politicians_carousel/image_with_progress_bar_widget.dart';

/// Карточка профиля политика
class PoliticianProfileCard extends StatelessWidget {
  const PoliticianProfileCard({
    super.key,
    required this.politician,
    this.onApprove,
    this.onDisapprove,
  });
  final Politician politician;
  final VoidCallback? onApprove;
  final VoidCallback? onDisapprove;

  @override
  Widget build(BuildContext context) {
    // Базовые отступы и размеры — плавно адаптируемся под ширину
    return LayoutBuilder(
      builder: (context, c) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ======= Верхняя зона: аватар + ФИО/партия/дата + share =======
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageWithProgressBarWidget(
                    imageUrl: politician.imageUrl, rating: politician.rating),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Имя + share
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              politician.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.get("Body/p3-bold"),
                            ), // жирный, крупнее body
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child:
                                  AppIcons.icShare.svg(height: 20, width: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${politician.partyFull} • ${politician.country}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.get("Body/p3"),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'In office since: ${politician.inOfficeSinceText}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.get("Body/p3"),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ======= Список инициатив =======
            Column(
              children: [
                for (final tag in politician.policies)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        // Название инициативы
                        Expanded(
                          child: Text(
                            tag.title,
                            style: AppTextStyles.get("Body/p3"),
                          ),
                        ),
                        // Чип справа
                        Container(
                          height: 28,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: tag.bg,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tag.label,
                            
                            style: AppTextStyles.get("Body/p3"),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // ======= Кнопки Approve / Disapprove =======
            Row(
              children: [
                Expanded(
                  child: AppButtonWidget.leftIcon(
                    label: 'Approve',
                    onPressed: onApprove ?? () {},
                    intent: AppButtonWidgetIntent.success,
                    tone: AppButtonWidgetTone.subtle,
                    size: AppButtonWidgetSize.medium,
                    // Класс кнопки принимает IconData, поэтому используем Material-иконки
                    leftIcon: Icons.thumb_up_alt_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButtonWidget.leftIcon(
                    label: 'Disapprove',
                    onPressed: onDisapprove ?? () {},
                    intent: AppButtonWidgetIntent.danger,
                    tone: AppButtonWidgetTone.subtle,
                    size: AppButtonWidgetSize.medium,
                    leftIcon: Icons.thumb_down_alt_rounded,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
