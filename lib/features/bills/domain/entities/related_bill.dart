class RelatedBill {
  final int id;
  final int congressBillId;
  final String type;
  final int number;
  final String relation;
  final String note;
  final int relatedBillId;
  final String relatedBillTitle;
  final String relatedBillIntroducedDate;

  const RelatedBill({
    required this.id,
    required this.congressBillId,
    required this.type,
    required this.number,
    required this.relation,
    required this.note,
    required this.relatedBillId,
    required this.relatedBillTitle,
    required this.relatedBillIntroducedDate,
  });
}