import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/data/mapper.dart';
import 'package:pulse/features/bills/domain/entities/bill_poll_query.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bills_query.dart';
import '../../domain/entities/bill_amendment.dart';
import '../../domain/entities/bill_sponsor.dart';
import '../../domain/entities/bill_text.dart';
import '../../domain/entities/bill_crs_report.dart';
import '../../domain/repositories/bills_repository.dart';
import '../datasources/bills_remote_ds.dart';

@LazySingleton(as: BillsRepository)
class BillsRepositoryImpl implements BillsRepository {
  final BillsRemoteDataSource _ds;
  BillsRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, List<Bill>>> getBills(BillsQuery query) =>
      safeCall(() => _ds.getBills(query));

  @override
  Future<Either<Failure, Bill>> getBillDetail(String billId) =>
      safeCall(() => _ds.getBillDetail(billId));

  @override
  Future<Either<Failure, List<BillAmendment>>> getBillAmendments(int billId) =>
      safeCall(() async {
        final models = await _ds.getBillAmendments(billId);
        return models
            .map((m) => BillAmendment(
                  id: m.id,
                  billId: m.billId,
                  congressAmendmentId: m.congressAmendmentId,
                  title: m.title,
                  description: m.description,
                  introducedDate: m.introducedDate,
                ))
            .toList();
      });

  @override
  Future<Either<Failure, List<BillSponsor>>> getBillSponsors(int billId) =>
      safeCall(() async {
        final models = await _ds.getBillSponsors(billId);
        return models
            .map((m) => BillSponsor(
                  id: m.id,
                  billId: m.billId,
                  politicianId: m.politicianId,
                ))
            .toList();
      });

  @override
  Future<Either<Failure, BillText>> getBillText(int textId) =>
      safeCall(() async {
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
      });

  @override
  Future<Either<Failure, String>> downloadBillText(int textId) =>
      safeCall(() => _ds.downloadBillText(textId));

  @override
  Future<Either<Failure, List<BillCrsReport>>> getBillCrsReports(int billId) =>
      safeCall(() async {
        final models = await _ds.getBillCrsReports(billId);
        return models
            .map((m) => BillCrsReport(
                  id: m.id,
                  extId: m.extId,
                  title: m.title,
                  url: m.url,
                  publishedAt: m.publishedAt,
                  updatedAt: m.updatedAt,
                  summary: m.summary,
                  contentHtml: m.contentHtml,
                  contentText: m.contentText,
                ))
            .toList();
      });

  @override
  Future<Either<Failure, void>> voteForBill(BillPollQuery query) =>
      safeCall(() => _ds.voteForBill(query));

  @override
  Future<Either<Failure, void>> cancelVoteForBill(int voteId) =>
      safeCall(() => _ds.cancelVoteForBill(voteId));

  @override
  Future<Either<Failure, PollBreakdown>> getPollBreakDown(int pollId) =>
      safeCall(() => _ds.getPollBreakDown(pollId));
}
