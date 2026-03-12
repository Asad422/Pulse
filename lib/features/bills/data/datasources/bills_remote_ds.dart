import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/features/bills/domain/entities/bill_poll_query.dart';

import '../models/bill_model.dart';
import '../models/bill_amendment_model.dart';
import '../models/bill_sponsor_model.dart';
import '../models/bill_text_model.dart';
import '../models/bill_crs_report_model.dart';
import '../models/poll_breakdown_model.dart';
import '../../domain/entities/bills_query.dart';

@lazySingleton
class BillsRemoteDataSource {
  final Dio _dio;

  BillsRemoteDataSource(@Named('authDio') this._dio);

  /// Получение списка законопроектов
  Future<List<BillModel>> getBills(BillsQuery q) async {
    final resp = await _dio.get(
      '/bills/',
      queryParameters: {
        'skip': q.skip,
        'limit': 100,
        if (q.status != null) 'status': q.status,
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

  /// Получение детальной информации по законопроекту
  Future<BillModel> getBillDetail(String billId) async {
    final resp = await _dio.get('/bills/$billId/detail');
    return BillModel.fromJson(resp.data as Map<String, dynamic>);
  }

  /// Получение списка поправок (amendments) для законопроекта
  Future<List<BillAmendmentModel>> getBillAmendments(int billId) async {
    final resp = await _dio.get('/bills/$billId/amendments');
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => BillAmendmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Получение списка спонсоров законопроекта
  Future<List<BillSponsorModel>> getBillSponsors(int billId) async {
    final resp = await _dio.get('/bills/$billId/sponsors');
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => BillSponsorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Получение текста законопроекта по ID версии
  Future<BillTextModel> getBillText(int textId) async {
    final resp = await _dio.get('/bills/bill-texts/$textId');
    return BillTextModel.fromJson(resp.data as Map<String, dynamic>);
  }

  /// Загрузка файла текста законопроекта (возвращает содержимое или ссылку)
  Future<String> downloadBillText(int textId) async {
    final resp = await _dio.get('/bills/bill-texts/$textId/download');
    return resp.data.toString();
  }

  /// Получение CRS-отчётов по законопроекту
  Future<List<BillCrsReportModel>> getBillCrsReports(int billId) async {
    final resp = await _dio.get('/bills/$billId/crs');
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => BillCrsReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Голосование за законопроект
  Future<void> voteForBill(BillPollQuery query) async {
    await _dio.post('/polls/${query.pollId}/votes', data: {
      'choice': query.choice,
    });
  }

  /// Отмена голосования за законопроект
  Future<void> cancelVoteForBill(int voteId) async {
    await _dio.delete('/polls/votes/$voteId');
  }

  Future<PollBreakdownModel> getPollBreakDown(int pollId) async {
    final resp = await _dio.get('/polls/$pollId/demographics');
    return PollBreakdownModel.fromJson(resp.data as Map<String, dynamic>);
  }
}
