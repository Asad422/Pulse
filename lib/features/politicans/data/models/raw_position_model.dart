class RawPositionData {
  final String? chamber;
  final int? congress;
  final int? district;
  final int? startYear;
  final String? stateCode;
  final String? stateName;
  final String? memberType;

  const RawPositionData({
    this.chamber,
    this.congress,
    this.district,
    this.startYear,
    this.stateCode,
    this.stateName,
    this.memberType,
  });

  factory RawPositionData.fromJson(Map<String, dynamic> json) {
    return RawPositionData(
      chamber: json['chamber'] as String?,
      congress: json['congress'] as int?,
      district: json['district'] as int?,
      startYear: json['startYear'] as int?,
      stateCode: json['stateCode'] as String?,
      stateName: json['stateName'] as String?,
      memberType: json['memberType'] as String?,
    );
  }
}
