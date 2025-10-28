import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/bill_model.dart';
import '../../domain/entities/bills_query.dart';

@lazySingleton
class BillsRemoteDataSource {
  BillsRemoteDataSource(@Named('authDio') this._dio);
  final Dio _dio;

  Future<List<BillModel>> getBills(BillsQuery q) async {
    final resp = await _dio.get(
      '/bills/',
      queryParameters: {
        'skip': q.skip,
        'limit': q.limit,
        if (q.status != null) 'status': q.status,
        if (q.level != null) 'level': q.level,
        if (q.isFeatured != null) 'is_featured': q.isFeatured,
        if (q.q != null && q.q!.isNotEmpty) 'q': q.q,
        if (q.introducedFrom != null) 'introduced_from': q.introducedFrom,
        if (q.introducedTo != null) 'introduced_to': q.introducedTo,
        if (q.subject != null) 'subject': q.subject,
        if (q.committee != null) 'committee': q.committee,
        if (q.sponsor != null) 'sponsor': q.sponsor,
        if (q.sortBy != null) 'sort_by': q.sortBy,
        if (q.order != null) 'order': q.order,
      },
    );

    return BillModel.fromJsonList(resp.data as List<dynamic>);
  }

  Future<BillModel> getBillDetail(String billId) async {
    final resp = await _dio.get('/bills/$billId/detail');
    return BillModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
