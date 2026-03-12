import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/widgets/error_empty_state.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/filters/filters_bar.dart';
import '../../../../core/widgets/politicians_profile_card/politician.dart';
import '../../../../core/widgets/politicians_profile_card/politician_profile_card.dart';
import '../../../../core/widgets/skeletons/politician_card_skeleton.dart';

import '../../domain/entities/politicians_query.dart';
import '../../../profile/presentation/bloc/user_bloc.dart';
import '../bloc/politicians_bloc/politicians_bloc.dart';

class PoliticiansScreen extends StatefulWidget {
  const PoliticiansScreen({super.key});

  @override
  State<PoliticiansScreen> createState() => _PoliticiansScreenState();
}

class _PoliticiansScreenState extends State<PoliticiansScreen> {
  final _scrollController = ScrollController();
  String? _selectedChamber;
  String? _searchQuery;
  String? _lastRoute;
  bool _isReloading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPoliticiansIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentRoute = GoRouterState.of(context).uri.toString();
    // Если маршрут изменился на politicians (не детальный экран), загружаем данные
    if (currentRoute == AppPaths.politicians && currentRoute != _lastRoute) {
      _lastRoute = currentRoute;
      _loadPoliticiansIfNeeded();
    }
  }

  void _loadPoliticiansIfNeeded() {
    final bloc = context.read<PoliticiansBloc>();
    // Загружаем политиков если список пустой или если нет активного запроса
    if (bloc.state.items.isEmpty ||
        (bloc.state.status != PoliticiansStatus.loading && bloc.state.query == null)) {
      bloc.add(
        PoliticiansLoadRequested(
          PoliticiansQuery(
            limit: 20,
            chamber: _selectedChamber,
            q: _searchQuery,
          ),
        ),
      );
    }
  }

  /// Находит voteId по pollId из UserBloc в контексте
  int? _findVoteIdByPollId(BuildContext context, int pollId) {
    try {
      final userBloc = context.read<UserBloc>();
      final voteHistory = userBloc.state.voteHistory;
      for (final vote in voteHistory) {
        if (vote.pollId == pollId) {
          return vote.id;
        }
      }
    } catch (e) {
      debugPrint('UserBloc not found in context: $e');
    }
    return null;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PoliticiansBloc>().add(const PoliticiansLoadMoreRequested());
    }
  }

  void _reload() {
    setState(() => _isReloading = true);
    context.read<PoliticiansBloc>().add(
      PoliticiansLoadRequested(
        PoliticiansQuery(
          limit: 20,
          chamber: _selectedChamber,
          q: _searchQuery,
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<PoliticiansBloc>();
    final query = bloc.state.query ??
        PoliticiansQuery(limit: 20, chamber: _selectedChamber, q: _searchQuery);
    bloc.add(PoliticiansLoadRequested(query));
    await bloc.stream.firstWhere(
      (s) => s.status == PoliticiansStatus.success || s.status == PoliticiansStatus.failure,
    );
  }

  String _getCurrentTabLabel(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppPaths.bills)) {
      return 'Bills';
    } else if (location.startsWith(AppPaths.home)) {
      return 'Laws';
    } else if (location.startsWith(AppPaths.politicians)) {
      return 'Politicians';
    } else if (location.startsWith(AppPaths.profile)) {
      return 'Profile';
    }
    return 'Politicians';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Проверяем маршрут и загружаем данные при открытии вкладки
    final currentRoute = GoRouterState.of(context).uri.toString();
    if (currentRoute == AppPaths.politicians && currentRoute != _lastRoute) {
      _lastRoute = currentRoute;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPoliticiansIfNeeded();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(AppIcons.icLogo.path, height: 40, width: 80),
        ),
        leadingWidth: 96,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              _getCurrentTabLabel(context),
              style: AppTextStyles.titleT2,
            ),
          ),
          FiltersBar(
            selectedChamber: _selectedChamber,
            onChamberChanged: (chamber) {
              setState(() => _selectedChamber = chamber);
              _reload();
            },
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
              _reload();
            },
            onClearSearch: () {
              setState(() => _searchQuery = null);
              _reload();
            },
          ),
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<PoliticiansBloc, PoliticiansState>(
                  listenWhen: (prev, next) =>
                      prev.status == PoliticiansStatus.loading &&
                      (next.status == PoliticiansStatus.success ||
                          next.status == PoliticiansStatus.failure),
                  listener: (context, state) {
                    if (_isReloading) {
                      setState(() => _isReloading = false);
                    }
                  },
                ),
                BlocListener<PoliticiansBloc, PoliticiansState>(
                  listenWhen: (prev, next) =>
                        prev.isVoting == true &&
                        next.isVoting == false &&
                        next.status == PoliticiansStatus.success &&
                        next.failure == null,
                  listener: (context, state) {
                    try {
                      context.read<UserBloc>().add(UserVoteHistoryRequested());
                    } catch (e) {
                      debugPrint('UserBloc not available: $e');
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients &&
                          !state.hasReachedEnd &&
                          _scrollController.position.pixels >=
                              _scrollController.position.maxScrollExtent - 200) {
                        context.read<PoliticiansBloc>().add(const PoliticiansLoadMoreRequested());
                      }
                    });
                  },
                ),
              ],
              child: BlocBuilder<PoliticiansBloc, PoliticiansState>(
                buildWhen: (p, c) =>
                    p.status != c.status ||
                    p.items != c.items ||
                    p.failure != c.failure ||
                    p.hasReachedEnd != c.hasReachedEnd ||
                    p.isVoting != c.isVoting ||
                    p.votingPollId != c.votingPollId ||
                    p.votingChoice != c.votingChoice,
                builder: (context, state) {
                  if (_isReloading ||
                      state.status == PoliticiansStatus.initial ||
                      state.status == PoliticiansStatus.loading) {
                    return ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (ctx, i) => const PoliticianCardSkeleton(),
                    );
                  }

                  if (state.status == PoliticiansStatus.failure && state.items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: state.failure?.displayType == FailureDisplayType.fullScreen
                                ? ErrorEmptyState(
                                    onRetry: () => context.read<PoliticiansBloc>().add(PoliticiansLoadRequested(state.query ?? const PoliticiansQuery())),
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
                                      ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.items.isEmpty && state.status == PoliticiansStatus.success) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const Center(child: Text('No politicians found')),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: state.hasReachedEnd
                        ? state.items.length
                        : state.items.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (ctx, i) {
                      if (i >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final p = state.items[i];
                      final poll = (p.polls?.isNotEmpty ?? false) ? p.polls!.first : null;
                      final totalVotes = poll?.totalVotes ?? 0;
                      final votesFor = poll?.votesFor ?? 0;
                      final votesAgainst = poll?.votesAgainst ?? 0;
                      final rating = totalVotes > 0 ? (votesFor / totalVotes * 100).round() : 0;
                      final userVote = poll?.userVote;
                      final fullName = p.directOrderName?.isNotEmpty == true
                          ? p.directOrderName!
                          : '${p.firstName} ${p.lastName}';
                      final position = p.currentPosition?.position ??
                          p.currentPosition?.chamber ??
                          '';
                      final party = p.party.isNotEmpty ? p.party : 'Unknown';
                      final stateName = p.stateName ?? p.state;
                      final photo = (p.photoUrl?.isNotEmpty == true &&
                              p.photoUrl != null &&
                              Uri.tryParse(p.photoUrl!)?.hasAbsolutePath == true)
                          ? p.photoUrl!
                          : 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
                      final period = p.currentPosition?.period ?? '';

                      final isVotingThis = state.isVoting && state.votingPollId == poll?.id;

                      return GestureDetector(
                        onTap: () => context.push('/app/politicians/${p.bioguideId}'),
                        child: PoliticianProfileCard(
                          politician: Politician(
                            name: fullName,
                            party: party,
                            partyFull: '$party • $stateName',
                            state: stateName,
                            country: p.level == 'federal' ? 'USA' : p.level,
                            rating: rating.toDouble(),
                            imageUrl: photo,
                            inOfficeSinceText: position.isNotEmpty
                                ? position
                                : 'In office since $period',
                            policies: const [],
                            totalVotes: totalVotes,
                            votesFor: votesFor,
                            votesAgainst: votesAgainst,
                          ),
                          isSupportActive: userVote == true,
                          isOpposeActive: userVote == false,
                          isSupportLoading: isVotingThis && state.votingChoice == true,
                          isOpposeLoading: isVotingThis && state.votingChoice == false,
                          showRating: totalVotes > 0,
                          isVotingDisabled: state.status == PoliticiansStatus.loadingMore,
                          onApprove: () {
                            final pollId = poll?.id;
                            if (userVote == true) {
                              final voteId = pollId != null ? _findVoteIdByPollId(context, pollId) : null;
                              if (voteId != null && pollId != null) {
                                context.read<PoliticiansBloc>().add(PoliticianCancelVoteSubmitted(
                                  voteId: voteId,
                                  pollId: pollId,
                                  choice: true,
                                ));
                              }
                            } else {
                              if (pollId != null) {
                                context.read<PoliticiansBloc>().add(
                                  PoliticianVoteSubmitted(
                                    pollId: pollId,
                                    choice: true,
                                  ),
                                );
                              }
                            }
                          },
                          onDisapprove: () {
                            final pollId = poll?.id;
                            if (userVote == false) {
                              final voteId = pollId != null ? _findVoteIdByPollId(context, pollId) : null;
                              if (voteId != null && pollId != null) {
                                context.read<PoliticiansBloc>().add(PoliticianCancelVoteSubmitted(
                                  voteId: voteId,
                                  pollId: pollId,
                                  choice: false,
                                ));
                              }
                            } else {
                              if (pollId != null) {
                                context.read<PoliticiansBloc>().add(
                                  PoliticianVoteSubmitted(
                                    pollId: pollId,
                                    choice: false,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
