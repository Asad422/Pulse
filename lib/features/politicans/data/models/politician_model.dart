import '../../domain/entities/politician.dart';

class PoliticianModel extends Politician {
  const PoliticianModel({
    required super.politicianId,
    required super.bioguideId,
    required super.firstName,
    required super.lastName,
    required super.party,
    required super.state,
    required super.level,
    super.photoUrl,
    super.fullName,
    super.directOrderName,
    super.chamber,
    super.stateName,
    super.sponsoredBillCount,
    super.cosponsoredBillCount,
    super.currentPosition,
  });

  factory PoliticianModel.fromJson(Map<String, dynamic> json) {
    return PoliticianModel(
      politicianId: json['politician_id'] as String,
      bioguideId: json['bioguide_id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      party: json['party'] as String? ?? '',
      state: json['state'] as String? ?? '',
      level: json['level'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      fullName: json['full_name'] as String?,
      directOrderName: json['direct_order_name'] as String?,
      chamber: json['chamber'] as String?,
      stateName: json['state_name'] as String?,
      sponsoredBillCount: json['sponsored_bill_count'] as int?,
      cosponsoredBillCount: json['cosponsored_bill_count'] as int?,
      currentPosition: json['current_position'] != null
          ? CurrentPosition.fromJson(
        json['current_position'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}
