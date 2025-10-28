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
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text('Politician Details'),
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
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

            final poll = p.polls.isNotEmpty ? p.polls.first : null;
            final rating = poll != null && poll.totalVotes > 0
                ? (poll.votesFor / poll.totalVotes * 100)
                : 72.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  /// Фото и имя
                  Center(
                    child: Column(
                      children: [
                        ImageWithProgressBarWidget(
                          imageUrl: p.photoUrl ?? '',
                          rating: rating,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.directOrderName ?? '${p.firstName} ${p.lastName}',
                          style: AppTextStyles.titleT1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p.currentPosition?.position ?? '',
                          style: AppTextStyles.paragraphP2High,
                          textAlign: TextAlign.center,
                        ),
                        if (p.currentPosition?.period != null)
                          Text(
                            'In office: ${p.currentPosition!.period}',
                            style: AppTextStyles.paragraphP2High
                                .copyWith(color: AppColors.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// === BASIC INFO ===
                  _Section(
                    title: 'Basic Information',
                    children: [
                      _info('Party', p.party),
                      _info('State', p.stateName ?? p.state),
                      _info('District', p.district ?? '-'),
                      _info('Chamber', p.chamber),
                      _info('Level', p.level),
                      _info('Birth Year', p.birthYear?.toString() ?? '-'),
                      _info('Sex', p.sex ?? '-'),
                      _info('Current Member', p.currentMember ? 'Yes' : 'No'),
                      _info('Sponsored Bills',
                          p.sponsoredBillCount.toString()),
                      _info('Cosponsored Bills',
                          p.cosponsoredBillCount.toString()),
                      _info('Official Website', p.officialWebsiteUrl ?? '-'),
                    ],
                  ),

                  /// === CURRENT POSITION ===
                  if (p.currentPosition != null) ...[
                    const SizedBox(height: 20),
                    _Section(
                      title: 'Current Position',
                      children: [
                        _info('Chamber', p.currentPosition!.chamber ?? '-'),
                        _info('Position', p.currentPosition!.position ?? '-'),
                        _info('State', p.currentPosition!.state ?? '-'),
                        _info('District',
                            p.currentPosition!.district?.toString() ?? '-'),
                        _info('Period', p.currentPosition!.period ?? '-'),
                        _info('Start Year',
                            p.currentPosition!.startYear?.toString() ?? '-'),
                        _info('End Year',
                            p.currentPosition!.endYear?.toString() ?? '-'),
                        _info('Duration',
                            '${p.currentPosition!.durationYears ?? 0} years'),
                        _info('Is Current',
                            p.currentPosition!.isCurrent == true ? 'Yes' : 'No'),
                      ],
                    ),
                  ],

                  /// === TERMS ===
                  if (p.terms.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _Section(
                      title: 'Terms',
                      children: p.terms
                          .map((t) => Text(
                        '${t.chamber} (${t.startYear}-${t.endYear ?? ''}) • ${t.stateName} #${t.district}',
                        style: AppTextStyles.paragraphP2High,
                      ))
                          .toList(),
                    ),
                  ],

                  /// === MEMBERSHIPS ===
                  if (p.memberships.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _Section(
                      title: 'Memberships',
                      children: p.memberships
                          .map((m) => Text(
                        '${m.organization} (${m.role}) • ${m.startDate} → ${m.endDate ?? 'Present'}',
                        style: AppTextStyles.paragraphP2High,
                      ))
                          .toList(),
                    ),
                  ],

                  /// === ATTRIBUTES ===
                  if (p.attrs != null) ...[
                    const SizedBox(height: 20),
                    _Section(
                      title: 'Attributes',
                      children: [
                        _info('Leadership', p.attrs!.leadership ?? '-'),
                        _info(
                            'Committees',
                            p.attrs!.committees.isNotEmpty
                                ? p.attrs!.committees
                                .map((e) => e.name)
                                .join(', ')
                                : '-'),
                        _info(
                            'Party History',
                            p.attrs!.partyHistory
                                .map((e) =>
                            '${e.partyName} (${e.startYear}, ${e.partyAbbreviation})')
                                .join(', ')),
                        _info('Sponsored Count',
                            p.attrs!.sponsoredCount.toString()),
                        _info('Cosponsored Count',
                            p.attrs!.cosponsoredCount.toString()),
                        if (p.attrs!.sponsoredLegislation != null)
                          _info('Sponsored Legislation',
                              p.attrs!.sponsoredLegislation!.url),
                      ],
                    ),
                  ],

                  /// === POLLS ===
                  if (p.polls.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _Section(
                      title: 'Polls',
                      children: p.polls
                          .map((poll) => Text(
                        '${poll.title}: 👍 ${poll.votesFor} / 👎 ${poll.votesAgainst} (Total ${poll.totalVotes})',
                        style: AppTextStyles.paragraphP2High,
                      ))
                          .toList(),
                    ),
                  ],

                  /// === CONTACT ===
                  if (p.contact != null) ...[
                    const SizedBox(height: 20),
                    _Section(
                      title: 'Contact Information',
                      children: [
                        _info('Address', p.contact!.fullAddress ?? '-'),
                        _info('Phone', p.contact!.phone ?? '-'),
                        _info('City', p.contact!.city ?? '-'),
                        _info('State', p.contact!.state ?? '-'),
                        _info('ZIP', p.contact!.zip ?? '-'),
                      ],
                    ),
                  ],

                  /// === EXTRA INFO ===
                  const SizedBox(height: 20),
                  _Section(
                    title: 'Extra Info',
                    children: [
                      _info('Leadership', p.leadership ?? '-'),
                      _info('Depiction Attribution', p.depictionAttribution ?? '-'),
                      _info('Depiction', p.depiction ?? '-'),
                      _info('Sponsored Count', p.sponsoredCount?.toString() ?? '-'),
                      _info('Cosponsored Count', p.cosponsoredCount?.toString() ?? '-'),
                      _info('State Name', p.stateName ?? '-'),
                    ],
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Вспомогательный виджет для строки информации
  static Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text('$label:',
                  style: AppTextStyles.labelL3
                      .copyWith(color: AppColors.onSurfaceVariant))),
          Expanded(flex: 5, child: Text(value, style: AppTextStyles.paragraphP2High)),
        ],
      ),
    );
  }
}

/// Карточка-раздел
class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              AppTextStyles.titleT3.copyWith(color: AppColors.onSurface)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}
