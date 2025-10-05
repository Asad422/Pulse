import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/filters/filters_bar.dart';
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
  final _scrollController = ScrollController();
  String? _selectedLevel;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _bloc = BillsBloc(sl<GetBillsUseCase>());
    _loadBills();
    _scrollController.addListener(_onScroll);
  }

  void _loadBills() {
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _bloc.add(const BillsLoadMoreRequested());
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
          title: const Text('Bills'),
          backgroundColor: AppColors.background,
        ),
        body: Column(
          children: [
            FiltersBar(
              selectedLevel: _selectedLevel,
              onLevelChanged: (level) {
                setState(() => _selectedLevel = level);
                _loadBills();
              },
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
                _loadBills();
              },
              onClearSearch: () {
                setState(() => _searchQuery = null);
                _loadBills();
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

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: state.hasReachedEnd
                        ? state.items.length
                        : state.items.length + 1,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      if (i >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final bill = state.items[i];
                      return ListTile(
                        title: Text(bill.title),
                        subtitle: Text(
                            '${bill.level ?? ''} • ${bill.status} • ${bill.introducedDate.toString().split(' ').first}'),
                        onTap: () {},
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
