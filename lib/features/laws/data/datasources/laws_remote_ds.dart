import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/bills/data/models/bill_model.dart';
import 'package:pulse/features/bills/data/models/poll_breakdown_model.dart';
import '../models/law_model.dart';
import '../../domain/entities/laws_query.dart';

@lazySingleton
class LawsRemoteDataSource {
  LawsRemoteDataSource(@Named('authDio') this._dio);
  final Dio _dio;

  Future<List<LawModel>> getLaws(LawsQuery q) async {
    final resp = await _dio.get(
      '/laws/',
      queryParameters: {
        'skip': q.skip,
        'limit': q.limit,
        if (q.congress != null) 'congress': q.congress,
        if (q.lawType != null) 'law_type': q.lawType,
        if (q.lawNumber != null) 'law_number': q.lawNumber,
        if (q.billId != null) 'bill_id': q.billId,
        if (q.q != null && q.q!.isNotEmpty) 'search': q.q,
        if (q.introducedFrom != null) 'introduced_from': q.introducedFrom,
        if (q.introducedTo != null) 'introduced_to': q.introducedTo,
        if (q.sortBy != null) 'sort_by': q.sortBy,
        if (q.order != null) 'order': q.order,
      },
    );
    final data = resp.data as List<dynamic>;
    return data.map((e) => LawModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<LawModel> getLaw(int lawId) async {
    final resp = await _dio.get('/laws/$lawId');
    return LawModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<LawModel> getLawByIdentity({
    required int congress,
    required String lawType,
    required String lawNumber,
  }) async {
    final resp = await _dio.get(
      '/laws/identity/lookup',
      queryParameters: {
        'congress': congress,
        'law_type': lawType,
        'law_number': lawNumber,
      },
    );
    return LawModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> voteForLaw({
    required int pollId,
    required bool choice,
  }) async {
    await _dio.post('/polls/$pollId/votes', data: {
      'choice': choice,
    });
  }

  Future<void> cancelVoteForLaw(int voteId) async {
    await _dio.delete('/polls/votes/$voteId');
  }

  Future<PollBreakdownModel> getPollBreakDown(int pollId) async {
    final resp = await _dio.get('/polls/$pollId/demographics');
    return PollBreakdownModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<BillModel>> getBillsByIds(List<int> billIds) async {
    if (billIds.isEmpty) return [];
    final results = <BillModel>[];
    for (final id in billIds) {
      try {
        final resp = await _dio.get('/bills/$id/detail');
        results.add(BillModel.fromJson(resp.data as Map<String, dynamic>));
      } catch (_) {
        // Skip if bill not found
      }
    }
    return results;
  }
}
