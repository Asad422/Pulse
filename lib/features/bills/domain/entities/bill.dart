class Bill {
  final String congressBillId;
  final int congress;
  final String billNumber;
  final String title;
  final String summary;
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
  });
}
