import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/bill.dart';
import '../bloc/bill_detail_bloc.dart';

class BillDetailScreen extends StatefulWidget {
  final String billId;
  const BillDetailScreen({super.key, required this.billId});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  late final BillDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BillDetailBloc(sl());
    _bloc.add(BillDetailRequested(widget.billId));
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
          title: const Text('Bill Details'),
          backgroundColor: AppColors.background,
          scrolledUnderElevation: 0,
        ),
        body: BlocBuilder<BillDetailBloc, BillDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case BillDetailStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 3),
                );
              case BillDetailStatus.failure:
                return Center(
                  child: Text('Error: ${state.error}',
                      style: const TextStyle(color: Colors.red)),
                );
              case BillDetailStatus.success:
                return _BillDetailContent(bill: state.bill!);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class _BillDetailContent extends StatelessWidget {
  final Bill bill;
  const _BillDetailContent({required this.bill});

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 6),
    child: Text(text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  );

  Widget _field(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 3,
            child: Text('$label:',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15))),
        Expanded(
          flex: 5,
          child: Text(value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 15)),
        ),
      ],
    ),
  );

  Widget _listSection(String title, List<Map<String, dynamic>> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        ...items.map(
              (e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(e.toString(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bill.title,
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Bill #${bill.billNumber} (${bill.classification})',
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: 12),
          _field('Congress Bill ID', bill.congressBillId),
          _field('Congress', bill.congress.toString()),
          _field('Status', bill.status),
          _field('Level', bill.level),
          _field('Introduced', bill.introducedDate.toString().split(' ').first),
          _field('Last Updated', bill.lastUpdated.toString().split(' ').first),
          _field('Featured', bill.isFeatured ? 'Yes' : 'No'),
          _field('Country', bill.countryCode),
          _field('Jurisdiction', bill.jurisdictionCode),
          _field('Source', bill.source),
          _field('Source ID', bill.sourceId),
          _field('External URL', bill.externalUrl),
          const SizedBox(height: 10),
          _sectionTitle('Summary'),
          Text(
            bill.summary?.isNotEmpty == true
                ? bill.summary!
                : 'No summary available.',
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          _listSection('Actions', bill.actions),
          _listSection('Amendments', bill.amendments),
          _listSection('Summaries', bill.summaries),
          _listSection('Texts', bill.texts),
          _listSection('CRS Reports', bill.crsReports),
          _listSection('Related Laws', bill.laws),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
