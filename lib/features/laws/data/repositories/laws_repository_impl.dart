import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/data/mapper.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';
import '../../domain/entities/law.dart';
import '../../domain/entities/laws_query.dart';
import '../../domain/entities/law_poll_query.dart';
import '../../domain/repositories/laws_repository.dart';
import '../datasources/laws_remote_ds.dart';

@LazySingleton(as: LawsRepository)
class LawsRepositoryImpl implements LawsRepository {
  LawsRepositoryImpl(this._ds);
  final LawsRemoteDataSource _ds;

  @override
  Future<Either<Failure, List<Law>>> getLaws(LawsQuery query) =>
      safeCall(() => _ds.getLaws(query));

  @override
  Future<Either<Failure, Law>> getLaw(int lawId) =>
      safeCall(() => _ds.getLaw(lawId));

  @override
  Future<Either<Failure, Law>> getLawByIdentity({
    required int congress,
    required String lawType,
    required String lawNumber,
  }) =>
      safeCall(() => _ds.getLawByIdentity(
            congress: congress,
            lawType: lawType,
            lawNumber: lawNumber,
          ));

  @override
  Future<Either<Failure, void>> voteForLaw(LawPollQuery query) =>
      safeCall(() => _ds.voteForLaw(pollId: query.pollId, choice: query.choice));

  @override
  Future<Either<Failure, void>> cancelVoteForLaw(int voteId) =>
      safeCall(() => _ds.cancelVoteForLaw(voteId));

  @override
  Future<Either<Failure, PollBreakdown>> getPollBreakDown(int pollId) =>
      safeCall(() => _ds.getPollBreakDown(pollId));

  @override
  Future<Either<Failure, List<Bill>>> getBillsByIds(List<int> billIds) =>
      safeCall(() => _ds.getBillsByIds(billIds));
}
