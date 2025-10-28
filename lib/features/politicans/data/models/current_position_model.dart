import 'package:pulse/features/politicans/data/models/raw_position_model.dart';

class CurrentPosition {
  final String? chamber;
  final String? chamberCode;
  final String? position;
  final String? state;
  final String? stateCode;
  final int? district;
  final String? period;
  final int? startYear;
  final int? endYear;
  final int? durationYears;
  final bool? isCurrent;
  final RawPositionData? rawData;

  const CurrentPosition({
    this.chamber,
    this.chamberCode,
    this.position,
    this.state,
    this.stateCode,
    this.district,
    this.period,
    this.startYear,
    this.endYear,
    this.durationYears,
    this.isCurrent,
    this.rawData,
  });

  factory CurrentPosition.fromJson(Map<String, dynamic> json) {
    return CurrentPosition(
      chamber: json['chamber'] as String?,
      chamberCode: json['chamber_code'] as String?,
      position: json['position'] as String?,
      state: json['state'] as String?,
      stateCode: json['state_code'] as String?,
      district: json['district'] is int
          ? json['district'] as int
          : int.tryParse(json['district']?.toString() ?? ''),
      period: json['period'] as String?,
      startYear: json['start_year'] as int?,
      endYear: json['end_year'] as int?,
      durationYears: json['duration_years'] as int?,
      isCurrent: json['is_current'] as bool?,
      rawData: json['raw_data'] != null
          ? RawPositionData.fromJson(json['raw_data'] as Map<String, dynamic>)
          : null,
    );
  }
}
