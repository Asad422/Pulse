import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/filters/filters_bar.dart';
import '../../../../core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';
import '../../domain/entities/laws_query.dart';
import '../../domain/usecases/get_laws_usecase.dart';
import '../bloc/laws_bloc.dart';

class LawsScreen extends StatefulWidget {
  const LawsScreen({super.key});

  @override
  State<LawsScreen> createState() => _LawsScreenState();
}

class _LawsScreenState extends State<LawsScreen> {
  late final LawsBloc _bloc;
  String? _selectedLevel;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _bloc = LawsBloc(sl<GetLawsUseCase>());
    _bloc.add(const LawsRequested(LawsQuery(limit: 20)));
  }

  void _reload() {
    _bloc.add(
      LawsRequested(
        LawsQuery(limit: 20, level: _selectedLevel, q: _searchQuery),
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
          title: const Text('Legislations'),
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
              child: BlocBuilder<LawsBloc, LawsState>(
                builder: (context, state) {
                  if (state.status == LawsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == LawsStatus.failure) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (state.items.isEmpty) {
                    return const Center(child: Text('No laws found'));
                  }

                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (ctx, i) {
                      final law = state.items[i];
                      return LegislationVoteCard(
                        title: law.title,
                        subtitle: '${law.lawType} ${law.lawNumber}',
                        status: LegislationStatus.inProgress,
                        introducedText:
                        'Enacted: ${law.enactedDate.toLocal().toString().split(' ').first}',
                        featured: true,
                        initialVotes: 0,
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
