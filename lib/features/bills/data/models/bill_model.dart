import '../../domain/entities/bill.dart';
import '../../../../core/network/data/models/poll_model.dart';
import 'action_model.dart';
import 'cosponsor_model.dart';
import 'related_bill_model.dart';

class BillModel extends Bill {
  const BillModel({
    required super.congressBillId,
    required super.congress,
    required super.billNumber,
    required super.title,
    required super.summary,
    required super.introducedDate,
    required super.status,
    required super.level,
    required super.isFeatured,
    required super.classification,
    required super.sessionId,
    required super.fromOrganizationId,
    required super.source,
    required super.sourceId,
    required super.countryCode,
    required super.jurisdictionCode,
    required super.externalUrl,
    required super.id,
    required super.lastUpdated,
    super.amendments = const [],
    super.summaries = const [],
    super.actions = const [],
    super.texts = const [],
    super.crsReports = const [],
    super.laws = const [],
    super.relatedBills = const [],
    super.cosponsors = const {},
    super.pollStats,
    super.userVote,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> _toList(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    }

    return BillModel(
      congressBillId: json['congress_bill_id'] as String? ?? '',
      congress: json['congress'] as int? ?? 0,
      billNumber: json['bill_number'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      introducedDate: DateTime.tryParse(json['introduced_date'] ?? '') ?? DateTime(1970),
      status: json['status'] as String? ?? '',
      level: json['level'] as String? ?? '',
      isFeatured: json['is_featured'] as bool? ?? false,
      classification: json['classification'] as String? ?? '',
      sessionId: json['session_id'] as int? ?? 0,
      fromOrganizationId: json['from_organization_id'] as int? ?? 0,
      source: json['source'] as String? ?? '',
      sourceId: json['source_id'] as String? ?? '',
      countryCode: json['country_code'] as String? ?? '',
      jurisdictionCode: json['jurisdiction_code'] as String? ?? '',
      externalUrl: json['external_url'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      lastUpdated: DateTime.tryParse(json['last_updated'] ?? '') ?? DateTime(1970),
      amendments: _toList(json['amendments']),
      summaries: _toList(json['summaries']),
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => ActionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      texts: _toList(json['texts']),
      crsReports: _toList(json['crs_reports']),
      laws: _toList(json['laws']),
      relatedBills: (json['related_bills'] as List<dynamic>?)
              ?.map((e) => RelatedBillModel.fromJson(e as Map<String, dynamic>).toEntity())
              .toList() ??
          const [],
      cosponsors: (json['cosponsors'] as List<dynamic>?)
              ?.map((e) => CosponsorModel.fromJson(e as Map<String, dynamic>).toEntity())
              .toSet() ??
          const {},
      pollStats: json['poll_stats'] != null
          ? PollModel.fromJson(json['poll_stats'] as Map<String, dynamic>)
          : null,
      userVote: json['user_vote'] as bool?,
    );
  }

  static List<BillModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => BillModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
