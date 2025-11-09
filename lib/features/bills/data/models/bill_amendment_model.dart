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
      id: json['id'] as int,
      billId: json['bill_id'] as int,
      congressAmendmentId: json['congress_amendment_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      introducedDate: DateTime.parse(json['introduced_date']),
    );
  }
}
