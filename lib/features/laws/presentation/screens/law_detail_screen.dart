import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/router/routes.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/di/di.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_empty_state.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';
import '../../../../core/widgets/skeletons/demographic_breakdown_skeleton.dart';
import '../../../../core/widgets/skeletons/law_detail_skeleton.dart';
import '../../../bills/presentation/widgets/demographic_breakdown_widget.dart';
import '../../../profile/presentation/bloc/user_bloc.dart';
import '../../domain/entities/law.dart';
import '../bloc/law_detail_bloc.dart';
import '../bloc/laws_bloc.dart';

class LawDetailScreen extends StatelessWidget {
  const LawDetailScreen({super.key, required this.lawId});

  final String lawId;

  @override
  Widget build(BuildContext context) {
    final lawsBloc = context.read<LawsBloc>();
    final lawIdInt = int.tryParse(lawId) ?? 0;

    return BlocProvider(
      create: (_) => LawDetailBloc(sl(), sl(), sl())
        ..add(LawDetailRequested(lawIdInt)),
      child: BlocProvider.value(
        value: lawsBloc,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Law', style: AppTextStyles.titleT3),
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
            ),
            scrolledUnderElevation: 0,
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<LawDetailBloc, LawDetailState>(
                listenWhen: (prev, next) =>
                    prev.status != LawDetailStatus.success &&
                    next.status == LawDetailStatus.success &&
                    next.law != null,
                listener: (context, state) {
                  final bloc = context.read<LawDetailBloc>();
                  final pollId = state.law!.pollStats?.id;
                  if (pollId != null) {
                    bloc.add(LawPollBreakDownRequested(pollId));
                  }
                  if (state.law!.billIds.isNotEmpty) {
                    bloc.add(LawRelatedBillsRequested(state.law!.billIds));
                  }
                },
              ),
              BlocListener<LawsBloc, LawsState>(
                listenWhen: (prev, next) =>
                    prev.isVoting == true &&
                    next.isVoting == false &&
                    next.failure == null,
                listener: (context, state) {
                  try {
                    context.read<UserBloc>().add(UserVoteHistoryRequested());
                  } catch (_) {}
                  final bloc = context.read<LawDetailBloc>();
                  final id = int.tryParse(lawId);
                  if (id != null) {
                    bloc.add(LawDetailRefreshRequested(id));
                  }
                  final pollId = bloc.state.law?.pollStats?.id;
                  if (pollId != null) {
                    bloc.add(LawPollBreakDownRequested(pollId));
                  }
                },
              ),
            ],
            child: BlocBuilder<LawDetailBloc, LawDetailState>(
              buildWhen: (p, c) => p.status != c.status || p.law != c.law || p.failure != c.failure,
              builder: (context, state) {
                switch (state.status) {
                  case LawDetailStatus.loading:
                    return const LawDetailSkeleton();
                  case LawDetailStatus.failure:
                    return state.failure?.displayType == FailureDisplayType.fullScreen
                        ? ErrorEmptyState(
                            onRetry: () {
                              final id = int.tryParse(lawId) ?? 0;
                              context.read<LawDetailBloc>().add(LawDetailRequested(id));
                            },
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
                  case LawDetailStatus.success:
                    if (state.law == null) {
                      return const Center(child: Text('Law not found'));
                    }
                    return _LawDetailContent(law: state.law!, lawId: lawId);
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

class _LawDetailContent extends StatelessWidget {
  const _LawDetailContent({required this.law, required this.lawId});

  final Law law;
  final String lawId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LawVoteCardSection(law: law, lawId: lawId),
          const SizedBox(height: 16),
          Divider(color: AppColors.onSurface),
          const SizedBox(height: 8),
          _LawDetailsSection(law: law),
          const _LawRelatedBillsSection(),
          _LawCongressLinkSection(url: law.url),
          const _LawPollBreakdownSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Vote Card Section ──────────────────────────────────────

class _LawVoteCardSection extends StatelessWidget {
  const _LawVoteCardSection({required this.law, required this.lawId});

  final Law law;
  final String lawId;

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
    return BlocBuilder<LawDetailBloc, LawDetailState>(
      buildWhen: (p, c) => p.law != c.law,
      builder: (context, detailState) {
        return BlocBuilder<LawsBloc, LawsState>(
          buildWhen: (p, c) =>
              p.isVoting != c.isVoting ||
              p.votingPollId != c.votingPollId ||
              p.votingChoice != c.votingChoice,
          builder: (context, lawsState) {
            final lawIdInt = int.tryParse(lawId);
            Law? currentLaw = detailState.law ?? law;

            if (lawIdInt != null) {
              try {
                currentLaw = lawsState.items.firstWhere((l) => l.id == lawIdInt);
              } catch (_) {
                currentLaw = detailState.law ?? law;
              }
            }

            final poll = currentLaw.pollStats;
            final initialSupport = poll?.votesFor ?? 0;
            final initialOppose = poll?.votesAgainst ?? 0;
            final userVote = currentLaw.userVote;
            final isVotingThis = lawsState.isVoting && lawsState.votingPollId == poll?.id;

            return Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: LegislationVoteCard(
                showStatus: false,
                title: currentLaw.title,
                subtitle: '${currentLaw.lawType} ${currentLaw.lawNumber}',
                introducedText: '',
                featured: false,
                initialVotes: initialSupport + initialOppose,
                initialSupport: initialSupport,
                initialOppose: initialOppose,
                isSupportLoading: isVotingThis && lawsState.votingChoice == true,
                isOpposeLoading: isVotingThis && lawsState.votingChoice == false,
                isSupportActive: userVote == true,
                isOpposeActive: userVote == false,
                isVotingDisabled: lawsState.status == LawsStatus.loadingMore,
                onApprove: () => _onVote(context, poll?.id, userVote, true),
                onDisapprove: () => _onVote(context, poll?.id, userVote, false),
              ),
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
        context.read<LawsBloc>().add(LawsCancelVoteSubmitted(
          voteId: voteId,
          pollId: pollId,
          choice: choice,
        ));
      }
    } else {
      context.read<LawsBloc>().add(LawsVoteSubmitted(pollId: pollId, choice: choice));
    }
  }
}

// ─── Details Section ────────────────────────────────────────

class _LawDetailsSection extends StatelessWidget {
  const _LawDetailsSection({required this.law});

  final Law law;

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: AppTextStyles.titleT2),
          const SizedBox(height: 16),
          _InfoRow(label: 'Congress', value: law.congress.toString()),
          _InfoRow(label: 'Law Type', value: law.lawType),
          _InfoRow(label: 'Law Number', value: law.lawNumber),
          if (law.url.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _openUrl(law.url),
              child: Text(
                'View on congress.gov',
                style: AppTextStyles.paragraphP2.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Related Bills Section ──────────────────────────────────

class _LawRelatedBillsSection extends StatelessWidget {
  const _LawRelatedBillsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LawDetailBloc, LawDetailState>(
      buildWhen: (p, c) =>
          p.relatedBillsStatus != c.relatedBillsStatus ||
          p.relatedBills != c.relatedBills,
      builder: (context, state) {
        if (state.relatedBillsStatus == LawRelatedBillsStatus.loading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Divider(color: AppColors.onSurface),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _RelatedBillsSkeleton(),
              ),
            ],
          );
        }
        if (state.relatedBills.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Divider(color: AppColors.onSurface),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Related Bills', style: AppTextStyles.titleT2),
            ),
            const SizedBox(height: 12),
            ...state.relatedBills.map((bill) => _RelatedBillItem(bill: bill)),
          ],
        );
      },
    );
  }
}

// ─── Poll Breakdown Section ─────────────────────────────────

class _LawPollBreakdownSection extends StatelessWidget {
  const _LawPollBreakdownSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LawDetailBloc, LawDetailState>(
      buildWhen: (p, c) =>
          p.pollBreakdownStatus != c.pollBreakdownStatus ||
          p.pollBreakdown != c.pollBreakdown,
      builder: (context, state) {
        if (state.pollBreakdownStatus == LawPollBreakdownStatus.loading) {
          return Column(
            children: [
              const SizedBox(height: 24),
              Divider(color: AppColors.onSurface),
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
              Divider(color: AppColors.onSurface),
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

// ─── Congress Link Section ───────────────────────────────────

class _LawCongressLinkSection extends StatelessWidget {
  const _LawCongressLinkSection({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Divider(color: AppColors.onSurface),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            final uri = Uri.tryParse(url);
            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'See full details on congress.gov',
                style: AppTextStyles.paragraphP2.copyWith(color: AppColors.primary),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.open_in_new, size: 16, color: AppColors.primary),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Small Widgets ──────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.paragraphP2.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.paragraphP2.copyWith(color: AppColors.onBackground),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedBillItem extends StatelessWidget {
  const _RelatedBillItem({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRoutes.billDetail,
            pathParameters: {'id': bill.id.toString()},
          );
        },
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 22,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bill.title,
                    style: AppTextStyles.paragraphP2Bold.copyWith(color: AppColors.onBackground),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bill.congressBillId.toUpperCase(),
                    style: AppTextStyles.paragraphP3.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _RelatedBillsSkeleton extends StatelessWidget {
  const _RelatedBillsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: AppColors.surfaceContainerHigh.withOpacity(0.6),
        highlightColor: AppColors.surface.withOpacity(0.9),
        duration: const Duration(milliseconds: 1500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Related Bills', style: AppTextStyles.titleT2),
          const SizedBox(height: 12),
          const _SkeletonBillRow(),
          const _SkeletonBillRow(),
        ],
      ),
    );
  }
}

class _SkeletonBillRow extends StatelessWidget {
  const _SkeletonBillRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}
