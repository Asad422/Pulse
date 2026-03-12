import '../../domain/entities/cosponsor.dart';

class CosponsorModel {
  final int id;
  final int billId;
  final String politicianId;
  final String? sponsorshipDate;
  final bool? isOriginalSponsor;
  final bool? isOriginalCosponsor;
  final String? sponsorshipWithdrawnDate;
  final String? titlePrefix;
  final String? politicianName;
  final String? politicianParty;
  final String? politicianState;
  final String? politicianChamber;
  final String? politicianPhotoUrl;

  const CosponsorModel({
    required this.id,
    required this.billId,
    required this.politicianId,
    this.sponsorshipDate,
    this.isOriginalSponsor,
    this.isOriginalCosponsor,
    this.sponsorshipWithdrawnDate,
    this.titlePrefix,
    this.politicianName,
    this.politicianParty,
    this.politicianState,
    this.politicianChamber,
    this.politicianPhotoUrl,
  });

  factory CosponsorModel.fromJson(Map<String, dynamic> json) {
    return CosponsorModel(
      id: json['id'] as int? ?? 0,
      billId: json['bill_id'] as int? ?? 0,
      politicianId: json['politician_id'] as String? ?? '',
      sponsorshipDate: json['sponsorship_date'] as String?,
      isOriginalSponsor: json['is_original_sponsor'] as bool?,
      isOriginalCosponsor: json['is_original_cosponsor'] as bool?,
      sponsorshipWithdrawnDate: json['sponsorship_withdrawn_date'] as String?,
      titlePrefix: json['title_prefix'] as String?,
      politicianName: json['politician_name'] as String?,
      politicianParty: json['politician_party'] as String?,
      politicianState: json['politician_state'] as String?,
      politicianChamber: json['politician_chamber'] as String?,
      politicianPhotoUrl: json['politician_photo_url'] as String?,
    );
  }

  Cosponsor toEntity() {
    return Cosponsor(
      id: id,
      billId: billId,
      politicianId: politicianId,
      sponsorshipDate: sponsorshipDate,
      isOriginalSponsor: isOriginalSponsor,
      isOriginalCosponsor: isOriginalCosponsor,
      sponsorshipWithdrawnDate: sponsorshipWithdrawnDate,
      titlePrefix: titlePrefix,
      politicianName: politicianName,
      politicianParty: politicianParty,
      politicianState: politicianState,
      politicianChamber: politicianChamber,
      politicianPhotoUrl: politicianPhotoUrl,
    );
  }
}
