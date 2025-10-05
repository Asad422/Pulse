import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/politicians_profile_card/politician_dto.dart';
import '../../../../core/widgets/politicians_profile_card/politician_profile_card.dart';
import '../../domain/repositories/politicians_repository.dart';
import '../../domain/usecases/get_politicians_usecase.dart';
import '../bloc/politicians_bloc/politicians_bloc.dart';

class PoliticansScreen extends StatefulWidget {
  const PoliticansScreen({super.key});

  @override
  State<PoliticansScreen> createState() => _PoliticansScreenState();
}

class _PoliticansScreenState extends State<PoliticansScreen> {
  late final PoliticiansBloc _bloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = PoliticiansBloc(sl<GetPoliticiansUseCase>());
    _bloc.add(const PoliticiansLoadRequested(PoliticiansQuery(limit: 20)));
    _scrollController.addListener(_onScroll);
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
          title: const Text('Politicians'),
          backgroundColor: AppColors.background,
        ),
        body: BlocBuilder<PoliticiansBloc, PoliticiansState>(
          builder: (context, state) {
            if (state.status == PoliticiansStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == PoliticiansStatus.failure) {
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
                  : state.items.length + 1, // +1 для индикатора загрузки
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (ctx, i) {
                if (i >= state.items.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final p = state.items[i];

                // безопасные данные
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
                  onTap: () => context.push('/app/politicians/${p.bioguideId}'),
                  child: PoliticianProfileCard(
                    politician: Politician(
                      name: fullName,
                      party: party,
                      partyFull: '$party • $stateName',
                      state: stateName,
                      country: p.level == 'federal' ? 'USA' : p.level,
                      rating: 100,
                      imageUrl: photo,
                      inOfficeSinceText:
                      position.isNotEmpty ? position : 'In office since $period',
                      policies: const [],
                    ),
                  ),
                );
              },
            );

          },
        ),
      ),
    );
  }
}
