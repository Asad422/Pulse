import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/usecases/get_bills_usecase.dart';
import '../bloc/bills_bloc.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  late final BillsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BillsBloc(sl<GetBillsUseCase>());
    _bloc.add(const BillsRequested(limit: 20));
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
          title: const Text('Bills'),
          backgroundColor: AppColors.background,
        ),
        body: BlocBuilder<BillsBloc, BillsState>(
          builder: (context, state) {
            if (state.status == BillsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == BillsStatus.failure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state.items.isEmpty) {
              return const Center(child: Text('No bills found'));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (ctx, i) {
                final bill = state.items[i];
                return ListTile(
                  title: Text(bill.title),
                  subtitle: Text(bill.status),
                  onTap: () {
                    // TODO: переход на детали
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
