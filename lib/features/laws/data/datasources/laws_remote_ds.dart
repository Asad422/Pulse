import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
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
        if (q.level != null) 'level': q.level,
        if (q.q != null && q.q!.isNotEmpty) 'q': q.q,
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
}
