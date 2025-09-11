import '../../domain/entities/politician.dart';

class PoliticianModel extends Politician {
  const PoliticianModel({
    required super.bigguideId,
    required super.firstName,
    required super.lastName,
    required super.party,
    required super.state,
    required super.level,
    super.birthYear,
    super.photoUrl,
  });

  factory PoliticianModel.fromJson(Map<String, dynamic> json) {
    return PoliticianModel(
      bigguideId: json['bigguide_id'] as String,
      firstName:  json['first_name'] as String,
      lastName:   json['last_name']  as String,
      party:      json['party']      as String,
      state:      json['state']      as String,
      level:      json['level']      as String,
      birthYear:  (json['birth_year'] as num?)?.toInt(),
      photoUrl:   json['photo_url'] as String?,
    );
  }
}
