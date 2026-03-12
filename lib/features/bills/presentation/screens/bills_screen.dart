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
import '../../../../core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';
import '../../../../core/widgets/skeletons/legislation_card_skeleton.dart';
import '../../domain/entities/bills_query.dart';
import '../../../profile/presentation/bloc/user_bloc.dart';
import '../bloc/bills_bloc.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final _scrollController = ScrollController();
  String? _searchQuery;
  String? _lastRoute;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadBillsIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentRoute = GoRouterState.of(context).uri.toString();
    // Если маршрут изменился на bills (не детальный экран), загружаем данные
    if (currentRoute == AppPaths.bills && currentRoute != _lastRoute) {
      _lastRoute = currentRoute;
      _loadBillsIfNeeded();
    }
  }

  void _loadBillsIfNeeded() {
    final bloc = context.read<BillsBloc>();
    // Загружаем биллы если список пустой или если нет активного запроса
    if (bloc.state.items.isEmpty || 
        (bloc.state.status != BillsStatus.loading && bloc.state.query == null)) {
      bloc.add(
        const BillsRequested(
          query: BillsQuery(limit: 20, sortBy: 'last_updated', order: 'desc'),
        ),
      );
    }
  }

  /// Находит voteId для BillVote по pollId из UserBloc в контексте
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
      // UserBloc не найден в контексте
      debugPrint('UserBloc not found in context: $e');
    }
    return null;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BillsBloc>().add(const BillsLoadMoreRequested());
    }
  }

  void _reload() {
    context.read<BillsBloc>().add(
      BillsRequested(
        query: BillsQuery(
          limit: 20,
          q: _searchQuery,
          sortBy: 'last_updated',
          order: 'desc',
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<BillsBloc>();
    final query = bloc.state.query ??
        BillsQuery(limit: 20, q: _searchQuery, sortBy: 'last_updated', order: 'desc');
    bloc.add(BillsRequested(query: query));
    await bloc.stream.firstWhere(
      (s) => s.status == BillsStatus.success || s.status == BillsStatus.failure,
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
    return 'Bills'; // default
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
    if (currentRoute == AppPaths.bills && currentRoute != _lastRoute) {
      _lastRoute = currentRoute;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadBillsIfNeeded();
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    _getCurrentTabLabel(context),
                    style: AppTextStyles.headlineH4,
                  ),
                ],
              ),
            ),
            FiltersBar(
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
                  BlocListener<BillsBloc, BillsState>(
                    listenWhen: (prev, next) =>
                        prev.isVoting == true &&
                        next.isVoting == false &&
                        next.status == BillsStatus.success &&
                        next.failure == null,
                    listener: (context, state) {
                      try {
                        context.read<UserBloc>().add(UserVoteHistoryRequested());
                      } catch (e) {
                        debugPrint('UserBloc not available: $e');
                      }
                      // После голосования проверяем, нужно ли загрузить ещё
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients &&
                            !state.hasReachedEnd &&
                            _scrollController.position.pixels >=
                                _scrollController.position.maxScrollExtent - 200) {
                          context.read<BillsBloc>().add(const BillsLoadMoreRequested());
                        }
                      });
                    },
                  ),
                ],
                child: BlocBuilder<BillsBloc, BillsState>(
                  buildWhen: (p, c) =>
                      p.status != c.status ||
                      p.items != c.items ||
                      p.failure != c.failure ||
                      p.hasReachedEnd != c.hasReachedEnd ||
                      p.isVoting != c.isVoting ||
                      p.votingPollId != c.votingPollId ||
                      p.votingChoice != c.votingChoice,
                  builder: (context, state) {
                  if (state.status == BillsStatus.loading) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: 5,
                      itemBuilder: (ctx, i) => const LegislationCardSkeleton(),
                    );
                  }

                  if (state.status == BillsStatus.failure) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: state.failure?.displayType == FailureDisplayType.fullScreen
                                ? ErrorEmptyState(
                                    onRetry: () {
                                      final q = state.query ?? const BillsQuery();
                                      context.read<BillsBloc>().add(BillsRequested(query: q));
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
                                      ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const Center(child: Text('No bills found')),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedEnd
                        ? state.items.length
                        : state.items.length + 1,
                    // separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      if (i >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final bill = state.items[i];

                      final introduced =
                          bill.introducedDate.toLocal().toString().split(' ').first;

                      // ✅ Статистика голосов из poll_stats
                      final poll = bill.pollStats;
                      final initialSupport = poll?.votesFor ?? 0;
                      final initialOppose = poll?.votesAgainst ?? 0;

                      final isVotingThis =
                          state.isVoting && state.votingPollId == poll?.id;

                      // Флаг голосования пользователя приходит в самом bill
                      final userVote = bill.userVote;

                      /// 🏷️ Определяем визуальный статус карточки по статусу законопроекта
                      final LegislationStatus status;
                      final rawStatus = bill.status.toLowerCase();

                      if (rawStatus.contains('committee')) {
                        status = LegislationStatus.committeeReview;
                      } else if (rawStatus.contains('senate')) {
                        status = LegislationStatus.passedSenate;
                      } else if (rawStatus.contains('vote') ||
                          rawStatus.contains('pending')) {
                        status = LegislationStatus.pendingVote;
                      } else {
                        status = LegislationStatus.inProgress;
                      }

                      return LegislationVoteCard(
                        title: bill.title,
                        subtitle: '${bill.level.toUpperCase()} • ${bill.status}',
                        status: status,
                        introducedText: 'Introduced: $introduced',
                        featured: true,
                        initialVotes: (initialSupport + initialOppose),
                        initialSupport: initialSupport,
                        initialOppose: initialOppose,
                        isSupportLoading: isVotingThis && state.votingChoice == true,
                        isOpposeLoading: isVotingThis && state.votingChoice == false,
                        isSupportActive: userVote == true,
                        isOpposeActive: userVote == false,
                        isVotingDisabled: state.status == BillsStatus.loadingMore,
                        onTap: () {
                          context.push('/app/bills/${bill.id}');
                        },
                        onApprove: () {
                          final pollId = poll?.id;
                          if(userVote == true ){
                            // Находим voteId из voteHistory через UserBloc из контекста
                            final voteId = pollId != null ? _findVoteIdByPollId(context, pollId) : null;
                            if (voteId != null && pollId != null) {
                              context.read<BillsBloc>().add(BillsCancelVoteSubmitted(
                                voteId: voteId,
                                pollId: pollId,
                                choice: true, // отменяем поддержку
                              ));
                            }
                          }
                          else{
                            if (pollId != null) {
                              context.read<BillsBloc>().add(
                                    BillsVoteSubmitted(
                                      pollId: pollId,
                                      choice: true,
                                    ),
                                  );
                            }
                          }
                        },
                        onDisapprove: () {
                          if(userVote == false ){
                            // Находим voteId из voteHistory через UserBloc из контекста
                            final pollId = poll?.id;
                            final voteId = pollId != null ? _findVoteIdByPollId(context, pollId) : null;
                            if (voteId != null && pollId != null) {
                              context.read<BillsBloc>().add(BillsCancelVoteSubmitted(
                                voteId: voteId,
                                pollId: pollId,
                                choice: false, // отменяем оппозицию
                              ));
                            }
                          }
                          else{
                            final pollId = poll?.id;
                            if (pollId != null) {
                              context.read<BillsBloc>().add(BillsVoteSubmitted(
                                    pollId: pollId,
                                    choice: false,
                                  ),
                                );
                            }
                          }
                        },
                      );
                    },
                  ),
                  );
                },
              ),
            ),
        )],
        ),
      );
    
   
  }
}
