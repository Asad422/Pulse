import 'package:flutter/material.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/core/widgets/network_avatar.dart';
import 'package:pulse/core/widgets/politicians_profile_card/politician.dart';
import 'package:pulse/core/widgets/trending_politicians_carousel/image_with_progress_bar_widget.dart';

/// Карточка профиля политика
class PoliticianProfileCard extends StatelessWidget {
  const PoliticianProfileCard({
    super.key,
    required this.politician,
    this.onApprove,
    this.onDisapprove,
    this.isSupportActive = false,
    this.isOpposeActive = false,
    this.isSupportLoading = false,
    this.isOpposeLoading = false,
    this.showRating = true,
    this.isVotingDisabled = false,
  });
  final Politician politician;
  final VoidCallback? onApprove;
  final VoidCallback? onDisapprove;
  final bool isSupportActive;
  final bool isOpposeActive;
  final bool isSupportLoading;
  final bool isOpposeLoading;
  final bool showRating;
  final bool isVotingDisabled;

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
                showRating
                    ? ImageWithProgressBarWidget(
                        imageUrl: politician.imageUrl,
                        rating: politician.rating)
                    : NetworkAvatar(
                        url: politician.imageUrl,
                        size: 88,
                      ),
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
                          // InkWell(
                          //   onTap: () {},
                          //   borderRadius: BorderRadius.circular(16),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(4),
                          //     child:
                          //         AppIcons.icShare.svg(height: 20, width: 20),
                          //   ),
                          // ),
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

            SizedBox(height: 10),

            // ======= Статистика голосов =======
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Participants',
                        style: AppTextStyles.get("Body/p3")?.copyWith(color: Colors.grey.shade600) ?? 
                               AppTextStyles.paragraphP3.copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${politician.totalVotes}',
                        style: AppTextStyles.get("Body/p3-bold") ?? AppTextStyles.paragraphP3Bold,
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
                  Column(
                    children: [
                      Text(
                        'For',
                        style: AppTextStyles.get("Body/p3")?.copyWith(color: Colors.grey.shade600) ?? 
                               AppTextStyles.paragraphP3.copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${politician.votesFor}',
                        style: AppTextStyles.get("Body/p3-bold")?.copyWith(color: Colors.green) ?? 
                               AppTextStyles.paragraphP3Bold.copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
                  Column(
                    children: [
                      Text(
                        'Against',
                        style: AppTextStyles.get("Body/p3")?.copyWith(color: Colors.grey.shade600) ?? 
                               AppTextStyles.paragraphP3.copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${politician.votesAgainst}',
                        style: AppTextStyles.get("Body/p3-bold")?.copyWith(color: Colors.red) ?? 
                               AppTextStyles.paragraphP3Bold.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppButtonWidget.leftIcon(
                    label: isSupportActive ? 'Approved' : 'Approve',
                    onPressed: onApprove ?? () {},
                    isLoading: isSupportLoading,
                    enabled: !isVotingDisabled,
                    intent: AppButtonWidgetIntent.success,
                    tone: isSupportActive
                        ? AppButtonWidgetTone.solid
                        : AppButtonWidgetTone.subtle,
                    size: AppButtonWidgetSize.medium,
                    leftIcon: Icons.thumb_up_alt_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButtonWidget.leftIcon(
                    label: isOpposeActive ? 'Disapproved' : 'Disapprove',
                    onPressed: onDisapprove ?? () {},
                    isLoading: isOpposeLoading,
                    enabled: !isVotingDisabled,
                    intent: AppButtonWidgetIntent.danger,
                    tone: isOpposeActive
                        ? AppButtonWidgetTone.solid
                        : AppButtonWidgetTone.subtle,
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
