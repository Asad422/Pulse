import 'package:injectable/injectable.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bills_query.dart';
import '../../domain/entities/bill_amendment.dart';
import '../../domain/entities/bill_sponsor.dart';
import '../../domain/entities/bill_text.dart';
import '../../domain/entities/bill_crs_report.dart';
import '../../domain/repositories/bills_repository.dart';
import '../datasources/bills_remote_ds.dart';
import '../models/bill_amendment_model.dart';
import '../models/bill_sponsor_model.dart';
import '../models/bill_text_model.dart';
import '../models/bill_crs_report_model.dart';

@LazySingleton(as: BillsRepository)
class BillsRepositoryImpl implements BillsRepository {
  final BillsRemoteDataSource _ds;
  BillsRepositoryImpl(this._ds);

  @override
  Future<List<Bill>> getBills(BillsQuery query) => _ds.getBills(query);

  @override
  Future<Bill> getBillDetail(String billId) => _ds.getBillDetail(billId);

  @override
  Future<List<BillAmendment>> getBillAmendments(int billId) async {
    final models = await _ds.getBillAmendments(billId);
    return models
        .map(
          (m) => BillAmendment(
        id: m.id,
        billId: m.billId,
        congressAmendmentId: m.congressAmendmentId,
        title: m.title,
        description: m.description,
        introducedDate: m.introducedDate,
      ),
    )
        .toList();
  }

  @override
  Future<List<BillSponsor>> getBillSponsors(int billId) async {
    final models = await _ds.getBillSponsors(billId);
    return models
        .map(
          (m) => BillSponsor(
        id: m.id,
        billId: m.billId,
        politicianId: m.politicianId,
      ),
    )
        .toList();
  }

  @override
  Future<BillText> getBillText(int textId) async {
    final m = await _ds.getBillText(textId);
    return BillText(
      id: m.id,
      versionCode: m.versionCode,
      versionName: m.versionName,
      versionDate: m.versionDate,
      format: m.format,
      contentText: m.contentText,
      url: m.url,
      billId: m.billId,
    );
  }

  @override
  Future<String> downloadBillText(int textId) => _ds.downloadBillText(textId);

  @override
  Future<List<BillCrsReport>> getBillCrsReports(int billId) async {
    final models = await _ds.getBillCrsReports(billId);
    return models
        .map(
          (m) => BillCrsReport(
        id: m.id,
        extId: m.extId,
        title: m.title,
        url: m.url,
        publishedAt: m.publishedAt,
        updatedAt: m.updatedAt,
        summary: m.summary,
        contentHtml: m.contentHtml,
        contentText: m.contentText,
      ),
    )
        .toList();
  }
}
