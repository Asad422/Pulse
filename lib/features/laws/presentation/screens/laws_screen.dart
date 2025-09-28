import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/app/di/di.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';

import '../../domain/usecases/get_laws_usecase.dart';
import '../bloc/laws_bloc.dart';

class LawsScreen extends StatefulWidget {
  const LawsScreen({super.key});

  @override
  State<LawsScreen> createState() => _LawsScreenState();
}

class _LawsScreenState extends State<LawsScreen> {
  late final LawsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LawsBloc(sl<GetLawsUseCase>());
    _bloc.add(const LawsRequested());
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
          backgroundColor: AppColors.background,
          title: const Text('Legislations'),
        ),
        body: BlocBuilder<LawsBloc, LawsState>(
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
                  status: LegislationStatus.inProgress, // 👈 пока условный статус
                  introducedText: 'Enacted: ${law.enactedDate.toLocal().toString().split(' ').first}',
                  featured: true,
                  initialVotes: 0, // позже можно подставить реальные
                );
              },
            );
          },
        ),
      ),
    );
  }
}
