import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/resources/app_icons.dart';
import 'package:pulse/core/utils/date_formatter.dart';
import 'package:pulse/features/bills/presentation/widgets/amendment_item.dart';
import 'package:pulse/features/bills/presentation/widgets/bill_summary_content.dart';
import 'package:pulse/features/bills/presentation/widgets/cosponsor_item.dart';
import 'package:pulse/features/bills/presentation/widgets/demographic_breakdown_widget.dart';
import 'package:pulse/features/bills/presentation/widgets/related_bill_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/widgets/error_empty_state.dart';
import '../../../../core/widgets/expandable_section.dart';
import '../../../../core/widgets/skeletons/bill_detail_skeleton.dart';
import '../../../../core/widgets/skeletons/demographic_breakdown_skeleton.dart';
import '../../../../core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_amendment.dart';
import '../../domain/entities/cosponsor.dart';
import '../../domain/entities/related_bill.dart';
import '../../domain/entities/action.dart' as entities;
import '../../../profile/presentation/bloc/user_bloc.dart';
import '../bloc/bill_detail_bloc.dart';
import '../bloc/bills_bloc.dart';

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key, required this.billId});

  final String billId;

  @override
  Widget build(BuildContext context) {
    final billsBloc = context.read<BillsBloc>();

    return BlocProvider(
      create: (_) => BillDetailBloc(sl(), sl(), sl())
        ..add(BillDetailRequested(billId)),
      child: BlocProvider.value(
        value: billsBloc,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Legislation', style: AppTextStyles.titleT3),
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
            ),
            scrolledUnderElevation: 0,
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<BillDetailBloc, BillDetailState>(
                listenWhen: (prev, next) =>
                    prev.status != BillDetailStatus.success &&
                    next.status == BillDetailStatus.success &&
                    next.bill != null,
                listener: (context, state) {
                  final bloc = context.read<BillDetailBloc>();
                  bloc.add(BillDetailAmendmentsRequested(state.bill!.id));
                  final pollId = state.bill!.pollStats?.id;
                  if (pollId != null) {
                    bloc.add(PollBreakDownRequested(pollId));
                  }
                },
              ),
              BlocListener<BillsBloc, BillsState>(
                listenWhen: (prev, next) =>
                    prev.isVoting == true &&
                    next.isVoting == false &&
                    next.status == BillsStatus.success &&
                    next.failure == null,
                listener: (context, state) {
                  try {
                    context.read<UserBloc>().add(UserVoteHistoryRequested());
                  } catch (_) {}
                  final bloc = context.read<BillDetailBloc>();
                  final billIdInt = int.tryParse(billId);
                  final billInList = billIdInt != null &&
                      state.items.any((b) => b.id == billIdInt);
                  if (!billInList) {
                    bloc.add(BillDetailRefreshRequested(billId));
                  }
                  final pollId = bloc.state.bill?.pollStats?.id;
                  if (pollId != null) {
                    bloc.add(PollBreakDownRequested(pollId));
                  }
                },
              ),
            ],
            child: BlocBuilder<BillDetailBloc, BillDetailState>(
              buildWhen: (p, c) => p.status != c.status || p.bill != c.bill || p.failure != c.failure,
              builder: (context, state) {
                switch (state.status) {
                  case BillDetailStatus.loading:
                    return const BillDetailSkeleton();
                  case BillDetailStatus.failure:
                    return state.failure?.displayType == FailureDisplayType.fullScreen
                        ? ErrorEmptyState(
                            onRetry: () => context.read<BillDetailBloc>().add(BillDetailRequested(billId)),
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
                  case BillDetailStatus.success:
                    if (state.bill == null) {
                      return const Center(child: Text('Bill not found'));
                    }
                    return _BillDetailContent(bill: state.bill!, billId: billId);
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Content ────────────────────────────────────────────────

class _BillDetailContent extends StatelessWidget {
  const _BillDetailContent({required this.bill, required this.billId});

  final Bill bill;
  final String billId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BillVoteCardSection(bill: bill, billId: billId),
          const SizedBox(height: 24),
          _BillSummarySection(bill: bill),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ExpandableSection<entities.Action>(
              title: 'Actions',
              items: bill.actions,
              itemBuilder: (action) => _ActionItem(action: action),
              emptyMessage: 'No actions available.',
              initialCount: 5,
            ),
          ),
          _BillRelatedBillsSection(bill: bill),
          _BillCosponsorsSection(bill: bill),
          const _BillAmendmentsSection(),
          const _BillPollBreakdownSection(),
          _CongressLinkSection(url: bill.externalUrl),
        ],
      ),
    );
  }
}

// ─── Vote Card Section ──────────────────────────────────────

class _BillVoteCardSection extends StatelessWidget {
  const _BillVoteCardSection({required this.bill, required this.billId});

  final Bill bill;
  final String billId;

  int? _findVoteIdByPollId(BuildContext context, int pollId) {
    try {
      final userBloc = context.read<UserBloc>();
      for (final vote in userBloc.state.voteHistory) {
        if (vote.pollId == pollId) return vote.id;
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillDetailBloc, BillDetailState>(
      buildWhen: (p, c) => p.bill != c.bill,
      builder: (context, detailState) {
        return BlocBuilder<BillsBloc, BillsState>(
          buildWhen: (p, c) =>
              p.isVoting != c.isVoting ||
              p.votingPollId != c.votingPollId ||
              p.votingChoice != c.votingChoice,
          builder: (context, billsState) {
            final billIdInt = int.tryParse(billId);
            Bill? currentBill = detailState.bill ?? bill;

            if (billIdInt != null) {
              try {
                currentBill = billsState.items.firstWhere((b) => b.id == billIdInt);
              } catch (_) {
                currentBill = detailState.bill ?? bill;
              }
            }

            final poll = currentBill.pollStats;
            final initialSupport = poll?.votesFor ?? 0;
            final initialOppose = poll?.votesAgainst ?? 0;
            final userVote = currentBill.userVote;
            final isVotingThis = billsState.isVoting && billsState.votingPollId == poll?.id;

            final LegislationStatus status;
            final rawStatus = currentBill.status.toLowerCase();
            if (rawStatus.contains('committee')) {
              status = LegislationStatus.committeeReview;
            } else if (rawStatus.contains('senate')) {
              status = LegislationStatus.passedSenate;
            } else if (rawStatus.contains('vote') || rawStatus.contains('pending')) {
              status = LegislationStatus.pendingVote;
            } else {
              status = LegislationStatus.inProgress;
            }

            final introduced = currentBill.introducedDate.toLocal().toString().split(' ').first;

            return LegislationVoteCard(
                type: LegislationVoteCardType.large,
                title: currentBill.title,
                subtitle: '${currentBill.level.toUpperCase()} • ${currentBill.status}',
                status: status,
                introducedText: 'Introduced: $introduced',
                featured: currentBill.isFeatured,
                initialVotes: initialSupport + initialOppose,
                initialSupport: initialSupport,
                initialOppose: initialOppose,
                isSupportLoading: isVotingThis && billsState.votingChoice == true,
                isOpposeLoading: isVotingThis && billsState.votingChoice == false,
                isSupportActive: userVote == true,
                isOpposeActive: userVote == false,
                onApprove: () => _onVote(context, poll?.id, userVote, true),
                onDisapprove: () => _onVote(context, poll?.id, userVote, false),
              );
          },
        );
      },
    );
  }

  void _onVote(BuildContext context, int? pollId, bool? userVote, bool choice) {
    if (pollId == null) return;
    if (userVote == choice) {
      final voteId = _findVoteIdByPollId(context, pollId);
      if (voteId != null) {
        context.read<BillsBloc>().add(BillsCancelVoteSubmitted(
          voteId: voteId,
          pollId: pollId,
          choice: choice,
        ));
      }
    } else {
      context.read<BillsBloc>().add(BillsVoteSubmitted(pollId: pollId, choice: choice));
    }
  }
}

// ─── Summary Section ────────────────────────────────────────

class _BillSummarySection extends StatelessWidget {
  const _BillSummarySection({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: AppTextStyles.titleT2),
          const SizedBox(height: 16),
          BillSummaryContent(summary: bill.summary),
        ],
      ),
    );
  }
}

// ─── Related Bills Section ──────────────────────────────────

class _BillRelatedBillsSection extends StatelessWidget {
  const _BillRelatedBillsSection({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ExpandableSection<RelatedBill>(
        title: 'Related Bills',
        items: bill.relatedBills,
        itemBuilder: (rb) => RelatedBillItem(relatedBill: rb),
        emptyMessage: 'No related bills available.',
        initialCount: 3,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}

// ─── Cosponsors Section ─────────────────────────────────────

class _BillCosponsorsSection extends StatelessWidget {
  const _BillCosponsorsSection({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ExpandableSection<Cosponsor>(
        title: 'Cosponsors',
        items: bill.cosponsors.toList(),
        itemBuilder: (c) => CosponsorItem(cosponsor: c),
        emptyMessage: 'No cosponsors available.',
        initialCount: 3,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}

// ─── Amendments Section ─────────────────────────────────────

class _BillAmendmentsSection extends StatelessWidget {
  const _BillAmendmentsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillDetailBloc, BillDetailState>(
      buildWhen: (p, c) =>
          p.amendmentsStatus != c.amendmentsStatus || p.amendments != c.amendments,
      builder: (context, state) {
        if (state.amendmentsStatus == AmendmentsStatus.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ExpandableSection<BillAmendment>(
            title: 'Amendments',
            items: state.amendments,
            itemBuilder: (a) => AmendmentItem(amendment: a),
            emptyMessage: 'No amendments available.',
            initialCount: 3,
            titlePadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }
}

// ─── Poll Breakdown Section ─────────────────────────────────

class _BillPollBreakdownSection extends StatelessWidget {
  const _BillPollBreakdownSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillDetailBloc, BillDetailState>(
      buildWhen: (p, c) =>
          p.pollBreakdownStatus != c.pollBreakdownStatus ||
          p.pollBreakdown != c.pollBreakdown,
      builder: (context, state) {
        if (state.pollBreakdownStatus == PollBreakdownStatus.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DemographicBreakdownSkeleton(),
          );
        }
        if (state.pollBreakdown != null &&
            (state.pollBreakdown!.byAge.isNotEmpty ||
                state.pollBreakdown!.byLocation.isNotEmpty)) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DemographicBreakdownWidget(breakdown: state.pollBreakdown!),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─── Congress Link Section ───────────────────────────────────

class _CongressLinkSection extends StatelessWidget {
  const _CongressLinkSection({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          onPressed: () async {
            final uri = Uri.tryParse(url);
            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: AppTextStyles.paragraphP2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('See full details on congress.gov'),
              const SizedBox(width: 6),
              SvgPicture.asset(
                AppIcons.icLink.path,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Action Item ────────────────────────────────────────────

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.action});

  final entities.Action action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              DateFormatter.formatActionDate(action.actionDate),
              style: AppTextStyles.paragraphP3.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(width: 16),
            Text(
              action.chamber.isEmpty ? '–' : action.chamber,
              style: AppTextStyles.paragraphP3.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          action.actionText,
          style: AppTextStyles.paragraphP2Bold.copyWith(color: AppColors.onBackground),
        ),
      ],
    );
  }
}
