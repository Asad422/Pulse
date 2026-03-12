import 'package:dartz/dartz.dart';
import 'package:pulse/core/failure/failure.dart';

import '../entities/poll.dart';
import '../entities/vote.dart';

abstract class PollsRepository {
  Future<Either<Failure, List<Poll>>> getPolls({
    int skip = 0,
    int limit = 100,
    String? politicianId,
    int? billId,
  });

  Future<Either<Failure, Poll>> getPollById(int pollId);
  Future<Either<Failure, Poll>> getPollVotes(int pollId);
  Future<Either<Failure, List<Vote>>> getMyVotes();
  Future<Either<Failure, Vote>> createVote({required int pollId, required bool choice});
  Future<Either<Failure, void>> deleteVote(int voteId);
  Future<Either<Failure, void>> deleteAllVotes();
}
