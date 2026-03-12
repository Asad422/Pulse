class BillAmendmentModel {
  final int id;
  final int billId;
  final String congressAmendmentId;
  final String title;
  final String description;
  final DateTime introducedDate;

  BillAmendmentModel({
    required this.id,
    required this.billId,
    required this.congressAmendmentId,
    required this.title,
    required this.description,
    required this.introducedDate,
  });

  factory BillAmendmentModel.fromJson(Map<String, dynamic> json) {
    return BillAmendmentModel(
      id: json['id'] as int? ?? 0,
      billId: json['bill_id'] as int? ?? 0,
      congressAmendmentId: json['congress_amendment_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      introducedDate: DateTime.tryParse(json['introduced_date'] ?? '') ?? DateTime(1970),
    );
  }
}
