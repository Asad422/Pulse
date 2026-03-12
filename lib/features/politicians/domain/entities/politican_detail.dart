// domain/entities/politican_detail.dart
import 'package:pulse/features/politicians/data/models/poll_model.dart' as poll_model;

class PoliticianDetail {
  final String id;
  final String bioguideId;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? suffix;
  final String? directOrderName;
  final String? invertedOrderName;
  final String? honorificName;
  final String party;
  final String state;
  final String? district;
  final String chamber;
  final int? birthYear;
  final String? sex; // NEW
  final String? photoUrl;
  final String? photoAttribution; // NEW
  final String? officialWebsiteUrl;
  final bool currentMember;
  final int sponsoredBillCount;
  final int cosponsoredBillCount;
  final String level;
  final String? source;
  final String? sourceId;
  final String? countryCode;
  final String? jurisdictionCode;
  final String? congressUrl; // NEW
  final DateTime? updateDate;

  /// Исторические "сырые" термины (конгресс, годы и т.п.)
  final List<Term> terms;

  /// Расширенные термины (форматированные периоды, is_current и т.п.)
  /// Берём из `term_history` (предпочтительно) или `terms_formatted`
  final List<TermFormatted> termsFormatted;

  /// Атрибуты-блок
  final Attributes? attrs;

  /// Текущая позиция (расширенная)
  final CurrentPosition? currentPosition;

  /// Членства (комитеты/организации)
  final List<Membership> memberships;

  /// Старое поле офисных данных (если бэкенд когда-то вернёт их)
  final Office? office;

  /// Новый объект контакта
  final Contact? contact; // NEW

  /// Опросы
  final List<poll_model.Poll> polls;

  /// Дубли корневых полей, которые также могут дублироваться в attrs
  final String? stateName;
  final String? leadership; // NEW (корневое)
  final List<PartyHistory> partyHistory; // NEW (корневое)
  final String? depictionAttribution; // NEW (корневое)
  final int? sponsoredCount; // NEW (корневое)
  final int? cosponsoredCount; // NEW (корневое)
  final String? depiction; // NEW

  const PoliticianDetail({
    required this.id,
    required this.bioguideId,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.suffix,
    this.directOrderName,
    this.invertedOrderName,
    this.honorificName,
    required this.party,
    required this.state,
    this.district,
    required this.chamber,
    this.birthYear,
    this.sex,
    this.photoUrl,
    this.photoAttribution,
    this.officialWebsiteUrl,
    required this.currentMember,
    required this.sponsoredBillCount,
    required this.cosponsoredBillCount,
    required this.level,
    this.source,
    this.sourceId,
    this.countryCode,
    this.jurisdictionCode,
    this.congressUrl,
    this.updateDate,
    required this.terms,
    required this.termsFormatted,
    this.attrs,
    this.currentPosition,
    required this.memberships,
    this.office,
    this.contact,
    required this.polls,
    this.stateName,
    this.leadership,
    this.partyHistory = const [],
    this.depictionAttribution,
    this.sponsoredCount,
    this.cosponsoredCount,
    this.depiction,
  });
}

// ===== Sub-entities (без изменений, где не нужно) =====

class Term {
  final String chamber;
  final int? endYear;
  final int congress;
  final int district;
  final int startYear;
  final String stateCode;
  final String stateName;
  final String memberType;

  const Term({
    required this.chamber,
    this.endYear,
    required this.congress,
    required this.district,
    required this.startYear,
    required this.stateCode,
    required this.stateName,
    required this.memberType,
  });
}

class Attributes {
  final List<Committee> committees;
  final String? leadership;
  final DateTime? updateDate;
  final List<PartyHistory> partyHistory;
  final int sponsoredCount;
  final int cosponsoredCount;
  final LegislationLink? sponsoredLegislation;
  final LegislationLink? cosponsoredLegislation;

  const Attributes({
    required this.committees,
    this.leadership,
    this.updateDate,
    required this.partyHistory,
    required this.sponsoredCount,
    required this.cosponsoredCount,
    this.sponsoredLegislation,
    this.cosponsoredLegislation,
  });
}

class Committee {
  final String? name;
  const Committee({this.name});
}

class PartyHistory {
  final String partyName;
  final int startYear;
  final String partyAbbreviation;

  const PartyHistory({
    required this.partyName,
    required this.startYear,
    required this.partyAbbreviation,
  });
}

class LegislationLink {
  final String url;
  final int count;
  const LegislationLink({required this.url, required this.count});
}

class TermFormatted {
  final String chamber;
  final String chamberCode;
  final String position;
  final String state;
  final String stateCode;
  final int district;
  final String period;
  final int startYear;
  final int? endYear;
  final int durationYears;
  final bool isCurrent;
  final TermRawData rawData;

  const TermFormatted({
    required this.chamber,
    required this.chamberCode,
    required this.position,
    required this.state,
    required this.stateCode,
    required this.district,
    required this.period,
    required this.startYear,
    this.endYear,
    required this.durationYears,
    required this.isCurrent,
    required this.rawData,
  });
}

class TermRawData {
  final String chamber;
  final int congress;
  final int district;
  final int startYear;
  final String stateCode;
  final String stateName;
  final String memberType;
  final int? endYear;

  const TermRawData({
    required this.chamber,
    required this.congress,
    required this.district,
    required this.startYear,
    required this.stateCode,
    required this.stateName,
    required this.memberType,
    this.endYear,
  });
}

class Membership {
  final String organization;
  final String role;
  final String postLabel;
  final String startDate;
  final String? endDate;

  const Membership({
    required this.organization,
    required this.role,
    required this.postLabel,
    required this.startDate,
    this.endDate,
  });
}

class Office {
  final String address;
  final String city;
  final String state;
  final String district;
  final String zip;
  final String phone;
  final String fullAddress;

  const Office({
    required this.address,
    required this.city,
    required this.state,
    required this.district,
    required this.zip,
    required this.phone,
    required this.fullAddress,
  });
}

class Contact {
  final String? address;
  final String? city;
  final String? state;
  final String? district;
  final String? zip;
  final String? phone;
  final String? fullAddress;

  const Contact({
    this.address,
    this.city,
    this.state,
    this.district,
    this.zip,
    this.phone,
    this.fullAddress,
  });
}


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
}

class RawPositionData {
  final String? chamber;
  final int? congress;
  final int? district;
  final int? startYear;
  final String? stateCode;
  final String? stateName;
  final String? memberType;
  final int? endYear;

  const RawPositionData({
    this.chamber,
    this.congress,
    this.district,
    this.startYear,
    this.stateCode,
    this.stateName,
    this.memberType,
    this.endYear,
  });
}
