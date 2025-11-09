import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/filters/filters_bar.dart';
import '../../../../core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';
import '../../domain/entities/bills_query.dart';
import '../../domain/usecases/get_bills_usecase.dart';
import '../bloc/bills_bloc.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  late final BillsBloc _bloc;
  String? _selectedLevel;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _bloc = BillsBloc(sl<GetBillsUseCase>());
    _bloc.add(
      BillsRequested(
        query: BillsQuery(limit: 20, sortBy: 'last_updated', order: 'desc'),
      ),
    );
  }

  void _reload() {
    _bloc.add(
      BillsRequested(
        query: BillsQuery(
          limit: 20,
          level: _selectedLevel,
          q: _searchQuery,
          sortBy: 'last_updated',
          order: 'desc',
        ),
      ),
    );
  }

  @override
  void dispose() {
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
          backgroundColor: AppColors.background,
          title: const Text('Bills'),
        ),
        body: Column(
          children: [
            FiltersBar(
              selectedLevel: _selectedLevel,
              onLevelChanged: (level) {
                setState(() => _selectedLevel = level);
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
              child: BlocBuilder<BillsBloc, BillsState>(
                builder: (context, state) {
                  if (state.status == BillsStatus.loading &&
                      state.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == BillsStatus.failure) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state.items.isEmpty) {
                    return const Center(child: Text('No bills found'));
                  }

                  return ListView.builder(
                    itemCount: state.items.length,
                    // separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {

                      final bill = state.items[i];

                      final introduced =
                          bill.introducedDate?.toLocal().toString().split(' ').first ?? '-';

                      /// 🏷️ Определяем визуальный статус карточки по статусу законопроекта
                      final LegislationStatus status;
                      final rawStatus = (bill.status ?? '').toLowerCase();

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
                        subtitle:
                        '${bill.level?.toUpperCase() ?? ''} • ${bill.status ?? 'Unknown'}',
                        status: status,
                        introducedText: 'Introduced: $introduced',
                        featured: true,
                        initialVotes: 0,
                        onTap: () {
                          context.push('/app/bills/${bill.id}');
                        },
                        onApprove: () {
                          // TODO: обработка "Support"
                        },
                        onDisapprove: () {
                          // TODO: обработка "Oppose"
                        },

                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
