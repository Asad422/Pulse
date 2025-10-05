import 'package:pulse/features/politicans/domain/entities/politician.dart';

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
  final String? photoUrl;
  final String? officialWebsiteUrl;
  final bool currentMember;
  final int sponsoredBillCount;
  final int cosponsoredBillCount;
  final String level;
  final String? source;
  final String? sourceId;
  final String? countryCode;
  final String? jurisdictionCode;
  final DateTime? updateDate;
  final List<Term> terms;
  final Attributes? attrs;
  final List<TermFormatted> termsFormatted;
  final CurrentPosition? currentPosition;
  final List<Membership> memberships;
  final Office? office;
  final List<Poll> polls;
  final String? stateName;

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
    this.photoUrl,
    this.officialWebsiteUrl,
    required this.currentMember,
    required this.sponsoredBillCount,
    required this.cosponsoredBillCount,
    required this.level,
    this.source,
    this.sourceId,
    this.countryCode,
    this.jurisdictionCode,
    this.updateDate,
    required this.terms,
    this.attrs,
    required this.termsFormatted,
    this.currentPosition,
    required this.memberships,
    this.office,
    required this.polls,
    this.stateName,
  });
}

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

  const LegislationLink({
    required this.url,
    required this.count,
  });
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

class Poll {
  final int pollId;
  final String title;
  final DateTime createdAt;
  final int votesFor;
  final int votesAgainst;
  final int totalVotes;

  const Poll({
    required this.pollId,
    required this.title,
    required this.createdAt,
    required this.votesFor,
    required this.votesAgainst,
    required this.totalVotes,
  });
}
