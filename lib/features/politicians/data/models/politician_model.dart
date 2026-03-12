
import 'package:pulse/features/politicians/data/models/poll_model.dart';

import '../../domain/entities/politician.dart';
import 'current_position_model.dart';

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
    super.district,
    super.currentMember,
    super.polls,
  });

  factory PoliticianModel.fromJson(Map<String, dynamic> json) {
    return PoliticianModel(
      politicianId: json['politician_id']?.toString() ?? '',
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
      sponsoredBillCount: json['sponsored_bill_count'] as int? ?? 0,
      cosponsoredBillCount: json['cosponsored_bill_count'] as int? ?? 0,
      district: json['district']?.toString(),
      currentMember: json['current_member'] as bool? ?? false,
      currentPosition: json['current_position'] != null
          ? CurrentPosition.fromJson(
        json['current_position'] as Map<String, dynamic>,
      )
          : null,
      polls: json['polls'] != null
          ? (json['polls'] as List)
          .map((p) => Poll.fromJson(p as Map<String, dynamic>))
          .toList()
          : [],
    );
  }
}
