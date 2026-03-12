import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/network/domain/entities/vote.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/widgets/error_empty_state.dart';
import 'package:pulse/core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';
import 'package:pulse/core/widgets/skeletons/legislation_card_skeleton.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/features/profile/domain/entities/vote.dart';
import 'package:pulse/features/profile/presentation/bloc/user_bloc.dart';

class VoteHistoryScreen extends StatefulWidget {
  const VoteHistoryScreen({super.key});

  @override
  State<VoteHistoryScreen> createState() => _VoteHistoryScreenState();
}

class _VoteHistoryScreenState extends State<VoteHistoryScreen> {
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

     if(userBloc.state.voteHistory.isEmpty && userBloc.state.status != UserStatus.loading) {
      userBloc.add(UserVoteHistoryRequested());
     }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () {
            context.pop();
          },
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        title: const Text('All activity',style: AppTextStyles.titleT3,)
      ),

      body: BlocBuilder<UserBloc, UserState>(
        buildWhen: (p, c) =>
            p.status != c.status ||
            p.voteHistory != c.voteHistory ||
            p.failure != c.failure ||
            p.isLoadingVoteHistory != c.isLoadingVoteHistory,
        builder: (context, state) {
          if ((state.status == UserStatus.loading || state.isLoadingVoteHistory) && state.voteHistory.isEmpty) {
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: 5,
              separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.outline),
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: LegislationCardSkeleton(),
              ),
            );
          }
          if(state.status == UserStatus.failure) {
            return state.failure?.displayType == FailureDisplayType.fullScreen
                ? ErrorEmptyState(
                    onRetry: () => context.read<UserBloc>().add(UserVoteHistoryRequested()),
                  )
                : state.failure?.displayType == FailureDisplayType.empty
                    ? ErrorEmptyState(
                        title: 'Not found',
                        subtitle: state.failure?.message ?? 'The requested data was not found.',
                      )
                    : Center(child: Text(state.failure?.message ?? 'Something went wrong'));
          }
          if(state.voteHistory.isEmpty) {
            return const ErrorEmptyState(
              title: 'No votes yet',
              subtitle: 'Your voting activity will appear here.',
            );
          }
          
          // Сортируем голоса по дате (новые сначала)
          final sorted = List<Vote>.from(state.voteHistory)
            ..sort((a, b) => b.votedAt.compareTo(a.votedAt));

          List<Vote> filtered;
          switch (selectedIndex) {
            case 0:
              filtered = sorted;
              break;
            case 1:
              filtered = sorted.where((v) => v is BillVote).toList();
              break;
            case 2:
              filtered = sorted.where((v) => v is LawVote).toList();
              break;
            case 3:
              filtered = sorted.where((v) => v is PollVote).toList();
              break;
            default:
              filtered = sorted;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: List.generate(4, (index) {
                    final labels = ['All', 'Bills', 'Laws', 'Politicians'];
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        showCheckmark: false,
                        label: Text(labels[index]),
                        selected: isSelected,
                        onSelected: (_) => setState(() => selectedIndex = index),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceContainerLow,
                        labelStyle: AppTextStyles.paragraphP2.copyWith(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        shape: const StadiumBorder(),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              if (filtered.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'No votes in this category yet',
                      style: AppTextStyles.paragraphP2.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                )
              else
              Expanded(
                child: ListView.separated(
                 padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => Divider(height: 1,color: AppColors.outline,),
                  itemBuilder: (context, index) {
                    final vote = filtered[index];
                    return switch (vote) {
                      
                      BillVote(:final bill, :final choice) =>
                        _buildBillCard(context, bill, choice, vote.votedAt),
                      LawVote(:final law, :final choice) =>
                        _buildLawCard(context, law, choice, vote.votedAt),
                      PollVote(:final poll, :final choice) =>
                        _buildPollCard(context, poll, choice, vote.votedAt),
                      _ => const SizedBox.shrink(),
                    };
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBillCard(BuildContext context, bill, bool userChoice, DateTime votedAt) {
    final introduced = bill.introducedDate?.toLocal().toString().split(' ').first ?? '-';
    final poll = bill.pollStats;
    final initialSupport = poll?.votesFor ?? 0;
    final initialOppose = poll?.votesAgainst ?? 0;

    final LegislationStatus status;
    final rawStatus = (bill.status ?? '').toLowerCase();
    if (rawStatus.contains('committee')) {
      status = LegislationStatus.committeeReview;
    } else if (rawStatus.contains('senate')) {
      status = LegislationStatus.passedSenate;
    } else if (rawStatus.contains('vote')) {
      status = LegislationStatus.pendingVote;
    } else {
      status = LegislationStatus.inProgress;
    }

    return LegislationVoteCard(
      title: bill.title,
      subtitle: '${bill.level?.toUpperCase() ?? ''} • ${bill.status ?? 'Unknown'}',
      status: status,
      introducedText: 'Introduced: $introduced',
      featured: bill.isFeatured ?? false,
      initialVotes: (initialSupport + initialOppose),
      initialSupport: initialSupport,
      initialOppose: initialOppose,
      isSupportActive: userChoice == true,
      isOpposeActive: userChoice == false,
      showOnlySelectedButton: true,
      onTap: () {
        context.push('/app/bills/${bill.id}');
      },
    );
  }

  Widget _buildLawCard(BuildContext context, law, bool userChoice, DateTime votedAt) {
    final enacted = law.enactedDate.toLocal().toString().split(' ').first;
    final poll = law.pollStats;
    final initialSupport = poll?.votesFor ?? 0;
    final initialOppose = poll?.votesAgainst ?? 0;

    return LegislationVoteCard(
      title: law.title,
      subtitle: '${law.lawType} ${law.lawNumber}',
      status: LegislationStatus.inProgress,
      introducedText: 'Enacted: $enacted',
      featured: true,
      initialVotes: (initialSupport + initialOppose),
      initialSupport: initialSupport,
      initialOppose: initialOppose,
      isSupportActive: userChoice == true,
      isOpposeActive: userChoice == false,
      showOnlySelectedButton: true,
      onTap: () {
        // no-op
        context.push('/app/home/law/${law.id}');
      },
    );
  }

  Widget _buildPollCard(BuildContext context, poll, bool userChoice, DateTime votedAt) {
    final initialSupport = poll.votesFor;
    final initialOppose = poll.votesAgainst;
    final createdAt = DateFormat('MMMM d, yyyy').format(poll.createdAt);

    return LegislationVoteCard(
      title: poll.title,
      subtitle: null,
      status: LegislationStatus.pendingVote,
      introducedText: 'Created: $createdAt',
      featured: false,
      initialVotes: (initialSupport + initialOppose),
      initialSupport: initialSupport,
      initialOppose: initialOppose,
      isSupportActive: userChoice == true,
      isOpposeActive: userChoice == false,
      showOnlySelectedButton: true,
      onTap: poll.politicianBioguideId != null
          ? () {
              context.push('/app/politicians/${poll.politicianBioguideId}');
            }
          : null,
    );
  }
}