import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/bills/data/models/bill_model.dart';
import 'package:pulse/features/bills/data/models/poll_breakdown_model.dart';
import '../../domain/entities/politicians_query.dart';
import '../models/politician_model.dart';
import '../models/politican_detail_model.dart';

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
        if (q.state != null) 'state': q.state,
        if (q.party != null) 'party': q.party,
        if (q.congress == null) 'congress': 119 ,
        if (q.congress != null) 'congress': q.congress,
        if (q.chamber != null) 'chamber': q.chamber,
        if (q.q != null && q.q!.isNotEmpty) 'q': q.q,
        'current_only': q.currentOnly,
      },
      options:  Options(responseType: ResponseType.json),
    );

    final data = resp.data as List<dynamic>;
    return data
        .map((e) => PoliticianModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PoliticianDetailModel> getPoliticianById(String bioguideId) async {
    final resp = await _dio.get('/politicians/$bioguideId');
    return PoliticianDetailModel.fromJson(resp.data as Map<String, dynamic>);
  }

  /// Получение списка законопроектов, спонсором которых является политик
  Future<List<BillModel>> getSponsoredBills(String politicianId) async {
    final resp = await _dio.get('/politicians/$politicianId/sponsored');
    return BillModel.fromJsonList(resp.data as List<dynamic>);
  }

  /// Получение списка законопроектов, коспонсором которых является политик
  Future<List<BillModel>> getCosponsoredBills(String politicianId) async {
    final resp = await _dio.get('/politicians/$politicianId/cosponsored');
    return BillModel.fromJsonList(resp.data as List<dynamic>);
  }

  /// Получение демографической статистики по голосованию
  Future<PollBreakdownModel> getPollBreakDown(int pollId) async {
    final resp = await _dio.get('/polls/$pollId/breakdown');
    return PollBreakdownModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
