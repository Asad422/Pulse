import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/data/mapper.dart';
import '../../domain/entities/poll.dart';
import '../../domain/entities/vote.dart';
import '../../domain/repositories/polls_repository.dart';
import '../datasources/polls_remote_datasource.dart';

@LazySingleton(as: PollsRepository)
class PollsRepositoryImpl implements PollsRepository {
  final PollsRemoteDataSource remote;

  PollsRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Poll>>> getPolls({
    int skip = 0,
    int limit = 100,
    String? politicianId,
    int? billId,
  }) =>
      safeCall(() => remote.getPolls(
            skip: skip,
            limit: limit,
            politicianId: politicianId,
            billId: billId,
          ));

  @override
  Future<Either<Failure, Poll>> getPollById(int pollId) =>
      safeCall(() => remote.getPoll(pollId));

  @override
  Future<Either<Failure, List<Vote>>> getMyVotes() =>
      safeCall(() => remote.getMyVotes());

  @override
  Future<Either<Failure, Vote>> createVote({
    required int pollId,
    required bool choice,
  }) =>
      safeCall(() => remote.createVote(pollId: pollId, choice: choice));

  @override
  Future<Either<Failure, void>> deleteVote(int voteId) =>
      safeCall(() => remote.deleteVote(voteId));

  @override
  Future<Either<Failure, void>> deleteAllVotes() =>
      safeCall(() => remote.deleteAllVotes());

  @override
  Future<Either<Failure, Poll>> getPollVotes(int pollId) =>
      safeCall(() => remote.getPollVotes(pollId));
}
