import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/politicians_profile_card/policies_dto.dart';
import '../../../../core/widgets/politicians_profile_card/politician_dto.dart';
import '../../../../core/widgets/politicians_profile_card/politician_profile_card.dart';
import '../../../../core/widgets/trending_politicians_carousel/trending_politicians_carousel_widget.dart';

import '../../../../app/di/di.dart';
import '../../domain/repositories/politicians_repository.dart';
import '../../domain/usecases/get_politicians_usecase.dart';
import '../bloc/politicians_bloc.dart';

class PoliticansScreen extends StatefulWidget {
  const PoliticansScreen({super.key});

  @override
  State<PoliticansScreen> createState() => _PoliticansScreenState();
}

class _PoliticansScreenState extends State<PoliticansScreen> {
  late final PoliticiansBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PoliticiansBloc(sl<GetPoliticiansUseCase>());
    _bloc.add(PoliticiansLoadRequested(PoliticiansQuery(limit: 20)));
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
        appBar: AppBar(title: const Text('Politicians')),
        body: Column(
          children: [
            const TrendingPoliticiansCarousel(),
            Expanded(
              child: BlocBuilder<PoliticiansBloc, PoliticiansState>(
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
                    padding: const EdgeInsets.all(20),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (ctx, i) {
                      final p = state.items[i];
                      return PoliticianProfileCard(
                        politician: Politician(
                          name: '${p.firstName} ${p.lastName}',
                          party: p.party,
                          partyFull: p.party, // можно сделать маппер party→fullName
                          state: p.state,
                          country: 'USA',
                          rating: 100, // TODO: подставить реальный рейтинг, если будет в API
                          imageUrl: p.photoUrl ??
                              'https://via.placeholder.com/150',
                          inOfficeSinceText: 'Member since ${p.birthYear ?? '-'}',
                          policies: [
                            // TODO: подставить реальные policies, если будут в API
                            PolicyTag.green('Climate Action Plan'),
                            PolicyTag.blue('Healthcare Reform'),
                          ],
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
    );
  }
}
