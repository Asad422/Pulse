import 'package:injectable/injectable.dart';
import '../../domain/entities/poll.dart';
import '../../domain/entities/vote.dart';
import '../../domain/repositories/polls_repository.dart';
import '../datasources/polls_remote_datasource.dart';

@LazySingleton(as: PollsRepository)
class PollsRepositoryImpl implements PollsRepository {
  final PollsRemoteDataSource remote;

  PollsRepositoryImpl(this.remote);

  @override
  Future<List<Poll>> getPolls({
    int skip = 0,
    int limit = 100,
    String? politicianId,
    int? billId,
  }) =>
      remote.getPolls(
        skip: skip,
        limit: limit,
        politicianId: politicianId,
        billId: billId,
      );

  @override
  Future<Poll> getPollById(int pollId) => remote.getPoll(pollId);

  @override
  Future<List<Vote>> getMyVotes() => remote.getMyVotes();

  @override
  Future<Vote> createVote({
    required int pollId,
    required bool choice,
  }) =>
      remote.createVote(pollId: pollId, choice: choice);

  @override
  Future<void> deleteVote(int voteId) => remote.deleteVote(voteId);

  @override
  Future<void> deleteAllVotes() => remote.deleteAllVotes();

  @override
  Future<Poll> getPollVotes(int pollId) => remote.getPollVotes(pollId);
}
