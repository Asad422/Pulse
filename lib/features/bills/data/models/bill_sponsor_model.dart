class BillSponsorModel {
  final int id;
  final int billId;
  final String politicianId;

  BillSponsorModel({
    required this.id,
    required this.billId,
    required this.politicianId,
  });

  factory BillSponsorModel.fromJson(Map<String, dynamic> json) {
    return BillSponsorModel(
      id: json['id'] as int,
      billId: json['bill_id'] as int,
      politicianId: json['politician_id'] ?? '',
    );
  }
}
