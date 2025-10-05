import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/features/politicans/presentation/bloc/politician_detail_bloc/politician_detail_bloc.dart';

import '../../../../app/di/di.dart';
import '../../../../core/widgets/promise_card.dart';
import '../../../../core/widgets/trending_politicians_carousel/image_with_progress_bar_widget.dart';

class PoliticianDetailScreen extends StatelessWidget {
  const PoliticianDetailScreen({super.key, required this.bioguideId});

  final String bioguideId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      PoliticianDetailBloc(sl())..add(PoliticianDetailRequested(bioguideId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          scrolledUnderElevation: 0, // ✅ отключает тень при скролле
          surfaceTintColor: Colors.transparent, // ✅ убирает потемнение
          title: const Text('Politician'),
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border_rounded),
              onPressed: () {},
            )
          ],
        ),
        body: BlocBuilder<PoliticianDetailBloc, PoliticianDetailState>(
          builder: (context, state) {
            if (state.status == PoliticianDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == PoliticianDetailStatus.failure) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final p = state.data;
            if (p == null) {
              return const Center(child: Text('No data'));
            }

            // --- данные из API ---
            final photoUrl = p.photoUrl ?? '';
            final name = p.directOrderName?.isNotEmpty == true
                ? p.directOrderName!
                : '${p.firstName} ${p.lastName}';
            final position = p.currentPosition?.position ?? '';
            final period = p.currentPosition?.period ?? '';
            final poll = p.polls.isNotEmpty ? p.polls.first : null;

            // вычисляем рейтинг (0–100)
            final rating = poll != null && poll.totalVotes > 0
                ? (poll.votesFor / (poll.totalVotes) * 100)
                : 72.0; // временно для примера

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // Фото + круговой рейтинг
                  Center(
                    child: ImageWithProgressBarWidget(
                      imageUrl: photoUrl,
                      rating: rating,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(name, style: AppTextStyles.titleT1),
                  const SizedBox(height: 6),
                  Text(
                    position,
                    style: AppTextStyles.paragraphP2High,
                    textAlign: TextAlign.center,
                  ),
                  if (period.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'In office: $period',
                      style: AppTextStyles.paragraphP2High.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 20),
                  Text(
                    'Overall Approval Rating',
                    style: AppTextStyles.paragraphP2High,
                  ),
                  if (poll != null)
                    Text(
                      '${poll.totalVotes} votes',
                      style: AppTextStyles.labelL3
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  const SizedBox(height: 20),

                  // Кнопки Support / Oppose
                  Row(
                    children: [
                      Expanded(
                        child: AppButtonWidget.leftIcon(
                          label: 'Support',
                          onPressed: () {},
                          intent: AppButtonWidgetIntent.success,
                          tone: AppButtonWidgetTone.subtle,
                          size: AppButtonWidgetSize.medium,
                          leftIcon: Icons.thumb_up_alt_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButtonWidget.leftIcon(
                          label: 'Oppose',
                          onPressed: () {},
                          intent: AppButtonWidgetIntent.danger,
                          tone: AppButtonWidgetTone.subtle,
                          size: AppButtonWidgetSize.medium,
                          leftIcon: Icons.thumb_down_alt_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  Divider(color: AppColors.surfaceContainerLow),
                  const SizedBox(height: 16),

                  // --- Promises Tracker ---
                  Row(
                    children: [
                      Text('Promises Tracker', style: AppTextStyles.titleT2),
                      const Spacer(),
                      Text(
                        '12 total',
                        style: AppTextStyles.paragraphP2High.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // пока фейковые данные — позже можно подставить реальные из API
                  const PromiseCard(
                    title: 'Infrastructure Investment',
                    dateText: 'Jan 2022',
                    body:
                    'Secured \$500M in federal funding for state highway repairs and public transit expansion.',
                    status: PromiseStatus.kept,
                  ),
                  const SizedBox(height: 12),
                  const PromiseCard(
                    title: 'Healthcare Reform',
                    dateText: 'Jan 2022',
                    body:
                    'Promised to expand Medicare coverage but voted against the Healthcare Expansion Act.',
                    status: PromiseStatus.broken,
                  ),
                  const SizedBox(height: 12),
                  const PromiseCard(
                    title: 'Climate Action Plan',
                    dateText: 'Jan 2022',
                    body:
                    'Proposed legislation for carbon neutrality by 2040 awaiting committee review.',
                    status: PromiseStatus.pending,
                  ),

                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('View all 12 promises'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: AppTextStyles.paragraphP2High,
                    ),
                  ),

                  const SizedBox(height: 32),
                  Divider(color: AppColors.surfaceContainerLow),

                  const SizedBox(height: 16),
                  Text('Voting history', style: AppTextStyles.titleT3),
                  const SizedBox(height: 8),
                  Text('Coming soon', style: AppTextStyles.paragraphP2High),
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
