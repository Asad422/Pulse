import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/bill_model.dart';

@lazySingleton
class BillsRemoteDataSource {
  BillsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<BillModel>> getBills({
    int skip = 0,
    int limit = 20,
    String? status,
    String? level,
    bool? isFeatured,
    String? q,
    String? introducedFrom,
    String? introducedTo,
    String? subject,
    String? committee,
    String? sponsor,
    String? sortBy,
    String? order,
  }) async {
    final resp = await _dio.get(
      '/bills/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (status != null) 'status': status,
        if (level != null) 'level': level,
        if (isFeatured != null) 'is_featured': isFeatured,
        if (q != null) 'q': q,
        if (introducedFrom != null) 'introduced_from': introducedFrom,
        if (introducedTo != null) 'introduced_to': introducedTo,
        if (subject != null) 'subject': subject,
        if (committee != null) 'committee': committee,
        if (sponsor != null) 'sponsor': sponsor,
        if (sortBy != null) 'sort_by': sortBy,
        if (order != null) 'order': order,
      },
    );
    return BillModel.fromJsonList(resp.data as List<dynamic>);
  }

  Future<BillModel> getBillDetail(String billId) async {
    final resp = await _dio.get('/bills/$billId/detail');
    return BillModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
