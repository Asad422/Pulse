import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_amendment.dart';
import '../../domain/entities/bill_sponsor.dart';
import '../../domain/entities/bill_text.dart';
import '../../domain/entities/bill_crs_report.dart';
import '../bloc/bill_detail_bloc.dart';

class BillDetailScreen extends StatefulWidget {
  final String billId;
  const BillDetailScreen({super.key, required this.billId});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  late final BillDetailBloc _bloc;
  bool _extraDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _bloc = BillDetailBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    )..add(BillDetailRequested(widget.billId));
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              onPressed: () {
                _extraDataLoaded = false;
                _bloc.add(BillDetailRequested(widget.billId));
              },
            ),
          ],
        ),
        body: BlocConsumer<BillDetailBloc, BillDetailState>(
          listener: (context, state) {
            if (!_extraDataLoaded &&
                state.status == BillDetailStatus.success &&
                state.bill != null) {
              final bill = state.bill!;
              _extraDataLoaded = true;

              _bloc.add(BillAmendmentsRequested(bill.id));
              _bloc.add(BillSponsorsRequested(bill.id));
              _bloc.add(BillCrsReportsRequested(bill.id));

              if (bill.texts.isNotEmpty && bill.texts.first['id'] != null) {
                _bloc.add(BillTextRequested(bill.texts.first['id'] as int));
              }
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case BillDetailStatus.loading:
                return const Center(child: CircularProgressIndicator(strokeWidth: 3));
              case BillDetailStatus.failure:
                return Center(
                  child: Text(
                    'Error: ${state.error ?? "Unknown error"}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              case BillDetailStatus.success:
                if (state.bill == null) {
                  return const Center(child: Text('Bill not found'));
                }
                return _BillDetailContent(state: state);
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
  final BillDetailState state;
  const _BillDetailContent({required this.state});

  Bill get bill => state.bill!;
  List<BillAmendment> get amendments => state.amendments;
  List<BillSponsor> get sponsors => state.sponsors;
  BillText? get billText => state.billText;
  List<BillCrsReport> get crsReports => state.crsReports;

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 6),
    child: Text(
      text,
      style: AppTextStyles.titleT3.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      ),
    ),
  );

  Widget _field(String label, String? value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '$label:',
            style: AppTextStyles.labelL3.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value?.isNotEmpty == true ? value! : '-',
            style: AppTextStyles.paragraphP2High,
          ),
        ),
      ],
    ),
  );

  Widget _list<T>(String title, List<T> items, String Function(T) formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        if (items.isEmpty)
          Text(
            'No data available.',
            style: AppTextStyles.paragraphP2High.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          ...items.map(
                (item) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                formatter(item),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Title =====
          Text(
            bill.title,
            style: AppTextStyles.titleT1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Bill #${bill.billNumber} (${bill.classification})',
            style: AppTextStyles.paragraphP2High.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // ===== General Info =====
          _sectionTitle('General Information'),
          _field('Congress Bill ID', bill.congressBillId),
          _field('Status', bill.status),
          _field('Level', bill.level),
          _field('Country', bill.countryCode),
          _field('Jurisdiction', bill.jurisdictionCode),
          _field('Source', bill.source),
          GestureDetector(
            onTap: () => _openUrl(bill.externalUrl),
            child: Text(
              bill.externalUrl ?? '-',
              style: AppTextStyles.paragraphP2High.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          _field('Introduced', bill.introducedDate?.toString().split(' ').first),

          // ===== Summary =====
          _sectionTitle('Summary'),
          Text(
            bill.summary?.isNotEmpty == true
                ? bill.summary!
                : 'No summary available.',
            style: AppTextStyles.paragraphP2High,
          ),

          // ===== Amendments =====
          _list<BillAmendment>(
            'Amendments',
            amendments,
                (a) =>
            '• ${a.title}\nIntroduced: ${a.introducedDate.toString().split(' ').first}\n${a.description}',
          ),

          // ===== Sponsors =====
          _list<BillSponsor>(
            'Sponsors',
            sponsors,
                (s) => '• Politician ID: ${s.politicianId}',
          ),

          // ===== Bill Text =====
          _sectionTitle('Bill Text'),
          if (billText == null)
            Text(
              'No text available.',
              style: AppTextStyles.paragraphP2High
                  .copyWith(color: AppColors.textSecondary),
            )
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                billText!.contentText.isNotEmpty
                    ? billText!.contentText
                    : 'Empty content.',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),

          // ===== CRS Reports =====
          _list<BillCrsReport>(
            'CRS Reports',
            crsReports,
                (r) =>
            '• ${r.title}\nPublished: ${r.publishedAt.toString().split(' ').first}\nSummary: ${r.summary}',
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
