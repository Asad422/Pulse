import 'package:dartz/dartz.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';

import '../entities/law.dart';
import '../entities/laws_query.dart';
import '../entities/law_poll_query.dart';

abstract class LawsRepository {
  Future<Either<Failure, List<Law>>> getLaws(LawsQuery query);
  Future<Either<Failure, Law>> getLaw(int lawId);
  Future<Either<Failure, Law>> getLawByIdentity({
    required int congress,
    required String lawType,
    required String lawNumber,
  });
  Future<Either<Failure, void>> voteForLaw(LawPollQuery query);
  Future<Either<Failure, void>> cancelVoteForLaw(int voteId);
  Future<Either<Failure, PollBreakdown>> getPollBreakDown(int pollId);
  Future<Either<Failure, List<Bill>>> getBillsByIds(List<int> billIds);
}
