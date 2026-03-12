import 'package:pulse/features/bills/domain/entities/related_bill.dart';

class RelatedBillModel {
  final int id;
  final int relatedCongress;
  final String relatedType;
  final String relatedNumber;
  final String? relation;
  final String? note;
  final int relatedBillId;
  final String relatedBillTitle;
  final String relatedBillIntroducedDate;

  const RelatedBillModel({
    required this.id,
    required this.relatedCongress,
    required this.relatedType,
    required this.relatedNumber,
    required this.relation,
    required this.note,
    required this.relatedBillId,
    required this.relatedBillTitle,
    required this.relatedBillIntroducedDate,
  });

  factory RelatedBillModel.fromJson(Map<String, dynamic> json) {
    return RelatedBillModel(
      id: json['id'] as int? ?? 0,
      relatedCongress: json['related_congress'] as int? ?? 0,
      relatedType: json['related_type'] as String? ?? '',
      relatedNumber: json['related_number'] as String? ?? '',
      relation: json['relation'] as String?,
      note: json['note'] as String?,
      relatedBillId: json['related_bill_id'] as int? ?? 0,
      relatedBillTitle: json['related_bill_title'] as String? ?? '',
      relatedBillIntroducedDate:
          json['related_bill_introduced_date'] as String? ?? '',
    );
  }

  RelatedBill toEntity() {
    return RelatedBill(
      id: id,
      congressBillId: relatedCongress,
      type: relatedType,
      number: int.tryParse(relatedNumber) ?? 0,
      relation: relation ?? '',
      note: note ?? '',
      relatedBillId: relatedBillId,
      relatedBillTitle: relatedBillTitle,
      relatedBillIntroducedDate: relatedBillIntroducedDate,
    );
  }
}
