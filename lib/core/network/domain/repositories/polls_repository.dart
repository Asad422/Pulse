import '../entities/poll.dart';
import '../entities/vote.dart';

abstract class PollsRepository {
  Future<List<Poll>> getPolls({
    int skip,
    int limit,
    String? politicianId,
    int? billId,
  });

  Future<Poll> getPollById(int pollId);
  Future<Poll> getPollVotes(int pollId);
  Future<List<Vote>> getMyVotes();
  Future<Vote> createVote({required int pollId, required bool choice});
  Future<void> deleteVote(int voteId);
  Future<void> deleteAllVotes();
}
