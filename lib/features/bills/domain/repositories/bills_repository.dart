import 'package:dartz/dartz.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/bill_poll_query.dart';

import '../entities/bill.dart';
import '../entities/bills_query.dart';
import '../entities/bill_amendment.dart';
import '../entities/bill_sponsor.dart';
import '../entities/bill_text.dart';
import '../entities/bill_crs_report.dart';
import '../entities/poll_breakdown.dart';

abstract class BillsRepository {
  Future<Either<Failure, List<Bill>>> getBills(BillsQuery query);
  Future<Either<Failure, Bill>> getBillDetail(String billId);
  Future<Either<Failure, List<BillAmendment>>> getBillAmendments(int billId);
  Future<Either<Failure, List<BillSponsor>>> getBillSponsors(int billId);
  Future<Either<Failure, BillText>> getBillText(int textId);
  Future<Either<Failure, String>> downloadBillText(int textId);
  Future<Either<Failure, List<BillCrsReport>>> getBillCrsReports(int billId);
  Future<Either<Failure, void>> voteForBill(BillPollQuery query);
  Future<Either<Failure, void>> cancelVoteForBill(int voteId);
  Future<Either<Failure, PollBreakdown>> getPollBreakDown(int pollId);
}
