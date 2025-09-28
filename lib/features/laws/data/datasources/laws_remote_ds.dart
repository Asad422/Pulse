import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/law_model.dart';

@lazySingleton
class LawsRemoteDataSource {
  LawsRemoteDataSource(@Named('authDio') this._dio);
  final Dio _dio;

  Future<List<LawModel>> getLaws({
    int? congress,
    String? lawType,
    String? lawNumber,
    int? billId,
  }) async {
    final resp = await _dio.get(
      '/laws/',
      queryParameters: {
        if (congress != null) 'congress': congress,
        if (lawType != null) 'law_type': lawType,
        if (lawNumber != null) 'law_number': lawNumber,
        if (billId != null) 'bill_id': billId,
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
