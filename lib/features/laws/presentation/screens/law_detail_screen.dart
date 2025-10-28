import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/law.dart';
import '../bloc/law_detail_bloc.dart';

class LawDetailScreen extends StatefulWidget {
  final String lawId;
  const LawDetailScreen({super.key, required this.lawId});

  @override
  State<LawDetailScreen> createState() => _LawDetailScreenState();
}

class _LawDetailScreenState extends State<LawDetailScreen> {
  late final LawDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LawDetailBloc(sl());
    final int id = int.tryParse(widget.lawId) ?? 0;
    _bloc.add(LawDetailRequested(id));
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
          title: const Text('Law Details'),
          backgroundColor: AppColors.background,
          scrolledUnderElevation: 0,
        ),
        body: BlocBuilder<LawDetailBloc, LawDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case LawDetailStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 3),
                );
              case LawDetailStatus.failure:
                return Center(
                  child: Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              case LawDetailStatus.success:
                final law = state.law!;
                return _LawDetailContent(law: law);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class _LawDetailContent extends StatelessWidget {
  final Law law;
  const _LawDetailContent({required this.law});

  Widget _field(String label, String value, {bool isLink = false}) {
    final textStyle = const TextStyle(fontSize: 15, height: 1.4);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          isLink
              ? InkWell(
            onTap: () {
              // можно открыть ссылку через url_launcher
            },
            child: Text(
              value,
              style: textStyle.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          )
              : Text(value.isNotEmpty ? value : '-', style: textStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enacted =
        law.enactedDate.toLocal().toString().split(' ').first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Title =====
          Text(
            law.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${law.lawType} ${law.lawNumber}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // ===== Fields =====
          _field('Law ID', law.id.toString()),
          _field('Congress', law.congress.toString()),
          _field('Law Type', law.lawType),
          _field('Law Number', law.lawNumber),
          _field('Enacted Date', enacted),
          _field('URL', law.url, isLink: true),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
