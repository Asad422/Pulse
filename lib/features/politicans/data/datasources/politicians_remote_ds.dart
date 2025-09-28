import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/politicians_repository.dart';
import '../models/politician_model.dart';

@lazySingleton
class PoliticiansRemoteDataSource {
  PoliticiansRemoteDataSource(@Named('authDio') this._dio);
  final Dio _dio;

  Future<List<PoliticianModel>> getPoliticians(PoliticiansQuery q) async {
    final resp = await _dio.get(
      '/politicians',
      queryParameters: {
        'skip': q.skip,
        'limit': q.limit,
        if (q.level != null) 'level': q.level,
        if (q.state != null) 'state': q.state,
        if (q.party != null) 'party': q.party,
      },
      options: Options(
        responseType: ResponseType.json,
      ),
    );

    final data = resp.data as List<dynamic>;
    return data.map((e) => PoliticianModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PoliticianModel> getPoliticianById(String bioguideId) async {
    final resp = await _dio.get('/politicians/$bioguideId');
    return PoliticianModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
