class BillAmendment {
  final int id;
  final int billId;
  final String congressAmendmentId;
  final String title;
  final String description;
  final DateTime introducedDate;

  BillAmendment({
    required this.id,
    required this.billId,
    required this.congressAmendmentId,
    required this.title,
    required this.description,
    required this.introducedDate,
  });
}
