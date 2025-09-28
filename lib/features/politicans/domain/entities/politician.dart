class Politician {
  final String politicianId;
  final String bioguideId;
  final String firstName;
  final String lastName;
  final String party;
  final String state;
  final String level;
  final String? photoUrl;
  final String? fullName;
  final String? directOrderName;
  final String? chamber;
  final String? stateName;
  final int? sponsoredBillCount;
  final int? cosponsoredBillCount;
  final CurrentPosition? currentPosition; // 👈 добавили

  const Politician({
    required this.politicianId,
    required this.bioguideId,
    required this.firstName,
    required this.lastName,
    required this.party,
    required this.state,
    required this.level,
    this.photoUrl,
    this.fullName,
    this.directOrderName,
    this.chamber,
    this.stateName,
    this.sponsoredBillCount,
    this.cosponsoredBillCount,
    this.currentPosition,
  });
}


class CurrentPosition {
  final String? chamber;
  final String? position;
  final String? state;
  final String? period;

  const CurrentPosition({
    this.chamber,
    this.position,
    this.state,
    this.period,
  });

  factory CurrentPosition.fromJson(Map<String, dynamic> json) {
    return CurrentPosition(
      chamber: json['chamber'] as String?,
      position: json['position'] as String?,
      state: json['state'] as String?,
      period: json['period'] as String?,
    );
  }
}
