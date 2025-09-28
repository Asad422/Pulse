import '../../domain/entities/bill.dart';

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
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      congressBillId: json['congress_bill_id'] as String? ?? '',
      congress: json['congress'] as int? ?? 0,
      billNumber: json['bill_number'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
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
    );
  }

  static List<BillModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => BillModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
