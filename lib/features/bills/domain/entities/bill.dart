import 'package:pulse/features/bills/domain/entities/related_bill.dart';

import '../../../../core/network/domain/entities/poll.dart';
import 'action.dart';
import 'cosponsor.dart';

class Bill {
  final String congressBillId;
  final int congress;
  final String billNumber;
  final String title;
  final String? summary;
  final DateTime introducedDate;
  final String status;
  final String level;
  final bool isFeatured;
  final String classification;
  final int sessionId;
  final int fromOrganizationId;
  final String source;
  final String sourceId;
  final String countryCode;
  final String jurisdictionCode;
  final String externalUrl;
  final int id;
  final DateTime lastUpdated;
  final List<RelatedBill> relatedBills;

  /// 🔹 Новые поля:
  final List<Map<String, dynamic>> amendments;
  final List<Map<String, dynamic>> summaries;
  final List<Action> actions;
  final List<Map<String, dynamic>> texts;
  final List<Map<String, dynamic>> crsReports;
  final List<Map<String, dynamic>> laws;
  final Set<Cosponsor> cosponsors;
  final Poll? pollStats;
  /// true = user voted \"support\", false = user voted \"oppose\", null = no vote
  final bool? userVote;

  const Bill({
    required this.congressBillId,
    required this.congress,
    required this.billNumber,
    required this.title,
    required this.summary,
    required this.introducedDate,
    required this.status,
    required this.level,
    required this.isFeatured,
    required this.classification,
    required this.sessionId,
    required this.fromOrganizationId,
    required this.source,
    required this.sourceId,
    required this.countryCode,
    required this.jurisdictionCode,
    required this.externalUrl,
    required this.id,
    required this.lastUpdated,
    this.amendments = const [],
    this.summaries = const [],
    this.actions = const [],
    this.texts = const [],
    this.crsReports = const [],
    this.laws = const [],
    this.relatedBills = const [],
    this.cosponsors = const {},
    this.pollStats,
    this.userVote,
  });
}
