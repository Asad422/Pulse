import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/poll_model.dart';
import '../models/vote_model.dart';

@lazySingleton
class PollsRemoteDataSource {
  final Dio dio;
  PollsRemoteDataSource(@Named('authDio') this.dio);

  Future<List<PollModel>> getPolls({
    int skip = 0,
    int limit = 100,
    String? politicianId,
    int? billId,
  }) async {
    final response = await dio.get('/api/v1/polls/', queryParameters: {
      'skip': skip,
      'limit': limit,
      if (politicianId != null) 'politician_id': politicianId,
      if (billId != null) 'bill_id': billId,
    });
    return (response.data as List)
        .map((e) => PollModel.fromJson(e))
        .toList();
  }

  Future<PollModel> getPoll(int id) async {
    final res = await dio.get('/api/v1/polls/$id');
    return PollModel.fromJson(res.data);
  }

  Future<List<VoteModel>> getMyVotes() async {
    final res = await dio.get('/api/v1/polls/votes');
    return (res.data as List).map((e) => VoteModel.fromJson(e)).toList();
  }

  Future<void> deleteAllVotes() async {
    await dio.delete('/polls/votes');
  }

  Future<void> deleteVote(int voteId) async {
    await dio.delete('/polls/votes/$voteId');
  }

  Future<VoteModel> createVote({
    required int pollId,
    required bool choice,
  }) async {
    final res = await dio.post('/polls/$pollId/votes', data: {
      'choice': choice,
    });
    return VoteModel.fromJson(res.data);
  }

  Future<PollModel> getPollVotes(int pollId) async {
    final res = await dio.get('/polls/$pollId/votes');
    return PollModel.fromJson(res.data);
  }
}
