import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/widgets/error_empty_state.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/core/widgets/skeletons/demographic_breakdown_skeleton.dart';
import 'package:pulse/core/widgets/skeletons/politician_detail_skeleton.dart';
import 'package:pulse/core/widgets/expandable_section.dart';
import 'package:pulse/core/widgets/network_avatar.dart';
import 'package:pulse/core/widgets/trending_politicians_carousel/circular_progress_bar_widget.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/bills/presentation/widgets/demographic_breakdown_widget.dart';
import 'package:pulse/features/politicians/domain/entities/politician.dart';
import 'package:pulse/features/politicians/domain/entities/politican_detail.dart';
import 'package:pulse/features/politicians/presentation/bloc/politician_detail_bloc/politician_detail_bloc.dart';
import 'package:pulse/features/politicians/presentation/bloc/politicians_bloc/politicians_bloc.dart';
import 'package:pulse/features/politicians/presentation/widgets/committee_membership_item.dart';
import 'package:pulse/features/politicians/presentation/widgets/politician_bill_item.dart';
import 'package:pulse/features/profile/presentation/bloc/user_bloc.dart';
import '../../../../app/di/di.dart';

class PoliticianDetailScreen extends StatelessWidget {
  const PoliticianDetailScreen({super.key, required this.bioguideId});

  final String bioguideId;

  @override
  Widget build(BuildContext context) {
    final politiciansBloc = context.read<PoliticiansBloc>();

    return BlocProvider(
      create: (_) => PoliticianDetailBloc(sl(), sl(), sl(), sl())
        ..add(PoliticianDetailRequested(bioguideId)),
      child: BlocProvider.value(
        value: politiciansBloc,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Politician', style: AppTextStyles.titleT3),
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
            ),
            scrolledUnderElevation: 0,
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<PoliticianDetailBloc, PoliticianDetailState>(
                listenWhen: (prev, next) =>
                    prev.status != PoliticianDetailStatus.success &&
                    next.status == PoliticianDetailStatus.success &&
                    next.data != null,
                listener: (context, state) {
                  final bloc = context.read<PoliticianDetailBloc>();
                  bloc.add(PoliticianSponsoredBillsRequested(bioguideId));
                  bloc.add(PoliticianCosponsoredBillsRequested(bioguideId));
                  final pollId = state.data!.polls.isNotEmpty ? state.data!.polls.first.id : null;
                  if (pollId != null) {
                    bloc.add(PoliticianPollBreakDownRequested(pollId));
                  }
                },
              ),
              BlocListener<PoliticiansBloc, PoliticiansState>(
                listenWhen: (prev, next) =>
                    prev.isVoting == true &&
                    next.isVoting == false &&
                    next.failure == null,
                listener: (context, state) {
                  try {
                    context.read<UserBloc>().add(UserVoteHistoryRequested());
                  } catch (_) {}
                  final bloc = context.read<PoliticianDetailBloc>();
                  bloc.add(PoliticianDetailRefreshRequested(bioguideId));
                  final pollId = bloc.state.data?.polls.isNotEmpty == true
                      ? bloc.state.data!.polls.first.id
                      : null;
                  if (pollId != null) {
                    bloc.add(PoliticianPollBreakDownRequested(pollId));
                  }
                },
              ),
            ],
            child: BlocBuilder<PoliticianDetailBloc, PoliticianDetailState>(
              buildWhen: (p, c) => p.status != c.status || p.data != c.data || p.failure != c.failure,
              builder: (context, state) {
                if (state.status == PoliticianDetailStatus.loading) {
                  return const PoliticianDetailSkeleton();
                }
                if (state.status == PoliticianDetailStatus.failure) {
                  return state.failure?.displayType == FailureDisplayType.fullScreen
                      ? ErrorEmptyState(
                          onRetry: () => context
                              .read<PoliticianDetailBloc>()
                              .add(PoliticianDetailRequested(bioguideId)),
                        )
                      : state.failure?.displayType == FailureDisplayType.empty
                          ? ErrorEmptyState(
                              title: 'Not found',
                              subtitle: state.failure?.message ?? 'The requested data was not found.',
                            )
                          : Center(
                              child: Text(
                                state.failure?.message ?? 'Something went wrong',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                }

                final p = state.data;
                if (p == null) return const Center(child: Text('No data'));

                return _PoliticianDetailContent(politician: p);
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Content ────────────────────────────────────────────────

class _PoliticianDetailContent extends StatelessWidget {
  const _PoliticianDetailContent({required this.politician});

  final PoliticianDetail politician;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _PoliticianHeaderSection(politician: politician),
          _PoliticianVoteSection(politician: politician),
          _PoliticianRatingSection(politician: politician),
          const SizedBox(height: 8),
          Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
          const SizedBox(height: 24),
          _PoliticianCommitteeSection(memberships: politician.memberships),
          Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
          const SizedBox(height: 24),
          const _PoliticianSponsoredBillsSection(),
          Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
          const SizedBox(height: 24),
          const _PoliticianCosponsoredBillsSection(),
          const _PoliticianPollBreakdownSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Header Section ─────────────────────────────────────────

class _PoliticianHeaderSection extends StatelessWidget {
  const _PoliticianHeaderSection({required this.politician});

  final PoliticianDetail politician;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          NetworkAvatar(url: politician.photoUrl, size: 128),
          const SizedBox(height: 16),
          Text(
            politician.directOrderName ?? '${politician.firstName} ${politician.lastName}',
            style: AppTextStyles.titleT2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            politician.currentPosition?.position ?? '',
            style: AppTextStyles.paragraphP2.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          if (politician.currentPosition?.period != null)
            Text(
              'In office : ${politician.currentPosition!.period}',
              style: AppTextStyles.paragraphP2High.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

// ─── Vote Section ───────────────────────────────────────────

class _PoliticianVoteSection extends StatelessWidget {
  const _PoliticianVoteSection({required this.politician});

  final PoliticianDetail politician;

  int? _findVoteIdByPollId(BuildContext context, int pollId) {
    try {
      final userBloc = context.read<UserBloc>();
      for (final vote in userBloc.state.voteHistory) {
        if (vote.pollId == pollId) return vote.id;
      }
    } catch (_) {}
    return null;
  }

  bool? _userVoteFromHistory(BuildContext context, int? pollId) {
    if (pollId == null) return null;
    try {
      final vote = context.read<UserBloc>().state.voteHistory
          .where((v) => v.pollId == pollId)
          .first;
      return vote.choice;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final poll = politician.polls.isNotEmpty ? politician.polls.first : null;
    final pollId = poll?.id;

    // Как в Bills: берём userVote из PoliticiansBloc.items (обновляется при _refreshAfterVote),
    // иначе из detail или vote history
    return BlocBuilder<PoliticiansBloc, PoliticiansState>(
      buildWhen: (p, c) =>
          p.items != c.items ||
          p.isVoting != c.isVoting ||
          p.votingPollId != c.votingPollId ||
          p.votingChoice != c.votingChoice,
      builder: (context, politiciansState) {
        final isVotingThis = politiciansState.isVoting && politiciansState.votingPollId == pollId;

        Politician? fromList;
        for (final p in politiciansState.items) {
          if (p.bioguideId == politician.bioguideId) {
            fromList = p;
            break;
          }
        }
        final listPoll = fromList?.polls?.isNotEmpty == true ? fromList!.polls!.first : null;
        final userVote = listPoll?.userVote ?? poll?.userVote ?? _userVoteFromHistory(context, pollId);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: AppButtonWidget.leftIcon(
                  label: userVote == true ? 'Approved' : 'Approve',
                      onPressed: () => _onVote(context, pollId, userVote, true),
                      isLoading: isVotingThis && politiciansState.votingChoice == true,
                      enabled: !(isVotingThis && politiciansState.votingChoice == false),
                      intent: AppButtonWidgetIntent.success,
                      tone: userVote == true ? AppButtonWidgetTone.solid : AppButtonWidgetTone.subtle,
                      size: AppButtonWidgetSize.medium,
                  leftIcon: Icons.thumb_up_alt_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButtonWidget.leftIcon(
                  label: userVote == false ? 'Disapproved' : 'Disapprove',
                      onPressed: () => _onVote(context, pollId, userVote, false),
                      isLoading: isVotingThis && politiciansState.votingChoice == false,
                      enabled: !(isVotingThis && politiciansState.votingChoice == true),
                      intent: AppButtonWidgetIntent.danger,
                      tone: userVote == false ? AppButtonWidgetTone.solid : AppButtonWidgetTone.subtle,
                      size: AppButtonWidgetSize.medium,
                  leftIcon: Icons.thumb_down_alt_rounded,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onVote(BuildContext context, int? pollId, bool? userVote, bool choice) {
    if (pollId == null) return;
    if (userVote == choice) {
      final voteId = _findVoteIdByPollId(context, pollId);
      if (voteId != null) {
        context.read<PoliticiansBloc>().add(PoliticianCancelVoteSubmitted(
          voteId: voteId,
          pollId: pollId,
          choice: choice,
        ));
      }
    } else {
      context.read<PoliticiansBloc>().add(PoliticianVoteSubmitted(
        pollId: pollId,
        choice: choice,
      ));
    }
  }
}

// ─── Rating Section ─────────────────────────────────────────

class _PoliticianRatingSection extends StatelessWidget {
  const _PoliticianRatingSection({required this.politician});

  final PoliticianDetail politician;

  @override
  Widget build(BuildContext context) {
    final poll = politician.polls.isNotEmpty ? politician.polls.first : null;
    final totalVotes = poll?.totalVotes ?? 0;
    final votesFor = poll?.votesFor ?? 0;
    final rating = totalVotes > 0 ? (votesFor / totalVotes * 100).roundToDouble() : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircularProgressBarWidget(
            fontSize: 16,
            lineHeight: 24,
            percent: rating / 100.0,
            size: 64,
          ),
          const SizedBox(height: 4),
          Text(
            'Overall Approval Rating',
            style: AppTextStyles.paragraphP2.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalVotes votes',
            style: AppTextStyles.paragraphP2.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─── Committee Section ──────────────────────────────────────

class _PoliticianCommitteeSection extends StatelessWidget {
  const _PoliticianCommitteeSection({required this.memberships});

  final List<Membership> memberships;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ExpandableSection<Membership>(
        title: 'Committee Membership',
        items: memberships,
        itemBuilder: (m) => CommitteeMembershipItem(membership: m),
        emptyMessage: 'No committee membership available.',
      ),
    );
  }
}

// ─── Sponsored Bills Section ────────────────────────────────

class _PoliticianSponsoredBillsSection extends StatelessWidget {
  const _PoliticianSponsoredBillsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoliticianDetailBloc, PoliticianDetailState>(
      buildWhen: (p, c) =>
          p.sponsoredBillsStatus != c.sponsoredBillsStatus ||
          p.sponsoredBills != c.sponsoredBills,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpandableSection<Bill>(
            title: 'Sponsored Bills',
            items: state.sponsoredBills,
            itemBuilder: (bill) => PoliticianBillItem(bill: bill),
            loading: state.sponsoredBillsStatus == BillsLoadStatus.loading
                ? const CircularProgressIndicator(strokeWidth: 2)
                : null,
            emptyMessage: 'No sponsored bills available.',
          ),
        );
      },
    );
  }
}

// ─── Cosponsored Bills Section ──────────────────────────────

class _PoliticianCosponsoredBillsSection extends StatelessWidget {
  const _PoliticianCosponsoredBillsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoliticianDetailBloc, PoliticianDetailState>(
      buildWhen: (p, c) =>
          p.cosponsoredBillsStatus != c.cosponsoredBillsStatus ||
          p.cosponsoredBills != c.cosponsoredBills,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpandableSection<Bill>(
            title: 'Cosponsored Bills',
            items: state.cosponsoredBills,
            itemBuilder: (bill) => PoliticianBillItem(bill: bill, isCosponsored: true),
            loading: state.cosponsoredBillsStatus == BillsLoadStatus.loading
                ? const CircularProgressIndicator(strokeWidth: 2)
                : null,
            emptyMessage: 'No cosponsored bills available.',
          ),
        );
      },
    );
  }
}

// ─── Poll Breakdown Section ─────────────────────────────────

class _PoliticianPollBreakdownSection extends StatelessWidget {
  const _PoliticianPollBreakdownSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoliticianDetailBloc, PoliticianDetailState>(
      buildWhen: (p, c) =>
          p.pollBreakdownStatus != c.pollBreakdownStatus ||
          p.pollBreakdown != c.pollBreakdown,
      builder: (context, state) {
        if (state.pollBreakdownStatus == PoliticianPollBreakdownStatus.loading) {
          return Column(
            children: [
              const SizedBox(height: 24),
              Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: DemographicBreakdownSkeleton(),
              ),
            ],
          );
        }
        if (state.pollBreakdown != null &&
            (state.pollBreakdown!.byAge.isNotEmpty ||
                state.pollBreakdown!.byLocation.isNotEmpty)) {
          return Column(
            children: [
              const SizedBox(height: 24),
              Divider(color: AppColors.onSurface.withOpacity(0.2), height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: DemographicBreakdownWidget(breakdown: state.pollBreakdown!),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
