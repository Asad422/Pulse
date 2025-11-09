import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/filters/filters_bar.dart';
import '../../../../core/widgets/politicians_profile_card/politician_dto.dart';
import '../../../../core/widgets/politicians_profile_card/politician_profile_card.dart';

import '../../domain/entities/politicians_query.dart';
import '../../domain/usecases/get_politicians_usecase.dart';
import '../../../../core/network/domain/usecases/create_vote_usecase.dart';
import '../bloc/politicians_bloc/politicians_bloc.dart';

class PoliticansScreen extends StatefulWidget {
  const PoliticansScreen({super.key});

  @override
  State<PoliticansScreen> createState() => _PoliticansScreenState();
}

class _PoliticansScreenState extends State<PoliticansScreen> {
  late final PoliticiansBloc _bloc;
  final _scrollController = ScrollController();

  String? _selectedLevel;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _bloc = PoliticiansBloc(
      sl<GetPoliticiansUseCase>(),
      sl<CreateVoteUseCase>(),
    );
    _loadInitial();
    _scrollController.addListener(_onScroll);
  }

  void _loadInitial() {
    _bloc.add(
      PoliticiansLoadRequested(
        PoliticiansQuery(
          limit: 20,
          level: _selectedLevel,
          q: _searchQuery,
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _bloc.add(const PoliticiansLoadMoreRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text('Politicians'),
          backgroundColor: AppColors.background,
        ),
        body: BlocListener<PoliticiansBloc, PoliticiansState>(
          listener: (context, state) {
            // Ошибки
            if (state.status == PoliticiansStatus.failure &&
                state.error != null) {
              if (state.error == 'already_voted') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have already voted for this poll ⚠️'),
                    backgroundColor: Colors.orangeAccent,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );
              }
            }
            // Успешное голосование
            else if (state.status == PoliticiansStatus.success &&
                state.voteJustSent != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.voteJustSent!.choice
                        ? 'You supported this politician 👍'
                        : 'You opposed this politician 👎',
                  ),
                  backgroundColor: state.voteJustSent!.choice
                      ? Colors.green
                      : Colors.redAccent,
                ),
              );
            }
          },
          child: Column(
            children: [
              // ===== Фильтр =====
              FiltersBar(
                selectedLevel: _selectedLevel,
                onLevelChanged: (level) {
                  setState(() => _selectedLevel = level);
                  _loadInitial();
                },
                onSearchChanged: (query) {
                  setState(() => _searchQuery = query);
                  _bloc.add(
                    PoliticiansLoadRequested(
                      PoliticiansQuery(
                        limit: 20,
                        level: _selectedLevel,
                        q: query,
                      ),
                    ),
                  );
                },
                onClearSearch: () {
                  setState(() => _searchQuery = null);
                  _bloc.add(
                    PoliticiansLoadRequested(
                      PoliticiansQuery(limit: 20, level: _selectedLevel),
                    ),
                  );
                },
              ),

              // ===== Список политиков =====
              Expanded(
                child: BlocBuilder<PoliticiansBloc, PoliticiansState>(
                  builder: (context, state) {
                    if (state.status == PoliticiansStatus.loading &&
                        state.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == PoliticiansStatus.failure &&
                        state.items.isEmpty) {
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state.items.isEmpty) {
                      return const Center(child: Text('No politicians found'));
                    }

                    return ListView.separated(
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
                        final rating = totalVotes > 0 ? (votesFor / totalVotes * 100).round() : 0;
                        final fullName = p.directOrderName?.isNotEmpty == true
                            ? p.directOrderName!
                            : '${p.firstName} ${p.lastName}';
                        final position = p.currentPosition?.position ??
                            p.currentPosition?.chamber ??
                            '';
                        final party = p.party.isNotEmpty ? p.party : 'Unknown';
                        final stateName = p.stateName ?? p.state ?? '';
                        final photo = p.photoUrl?.isNotEmpty == true
                            ? p.photoUrl!
                            : 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
                        final period = p.currentPosition?.period ?? '';

                        return GestureDetector(
                          onTap: () => context.push(
                            '/app/politicians/${p.bioguideId}',
                          ),
                          child: PoliticianProfileCard(
                            politician: Politician(
                              name: fullName,
                              party: party,
                              partyFull: '$party • $stateName',
                              state: stateName,
                              country: p.level == 'federal'
                                  ? 'USA'
                                  : (p.level ?? ''),
                              rating: rating.toDouble(),
                              imageUrl: photo,
                              inOfficeSinceText: position.isNotEmpty
                                  ? position
                                  : 'In office since $period',
                              policies: const [],
                            ),

                            // ✅ Используем встроенные кнопки карточки
                            onApprove: () {
                              final pollId = p.polls?.isNotEmpty == true
                                  ? p.polls!.first.pollId
                                  : null;
                              if (pollId != null) {
                                context.read<PoliticiansBloc>().add(
                                  PoliticianVoteSubmitted(
                                    pollId: pollId,
                                    choice: true,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Poll not available for this politician'),
                                  ),
                                );
                              }
                            },
                            onDisapprove: () {
                              final pollId = p.polls?.isNotEmpty == true
                                  ? p.polls!.first.pollId
                                  : null;
                              if (pollId != null) {
                                context.read<PoliticiansBloc>().add(
                                  PoliticianVoteSubmitted(
                                    pollId: pollId,
                                    choice: false,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Poll not available for this politician'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
