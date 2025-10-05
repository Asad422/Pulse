
import '../../domain/entities/politican_detail.dart';
import '../../domain/entities/politician.dart';

class PoliticianDetailModel extends PoliticianDetail {
  const PoliticianDetailModel({
    required super.id,
    required super.bioguideId,
    required super.firstName,
    required super.lastName,
    super.middleName,
    super.suffix,
    super.directOrderName,
    super.invertedOrderName,
    super.honorificName,
    required super.party,
    required super.state,
    super.district,
    required super.chamber,
    super.birthYear,
    super.photoUrl,
    super.officialWebsiteUrl,
    required super.currentMember,
    required super.sponsoredBillCount,
    required super.cosponsoredBillCount,
    required super.level,
    super.source,
    super.sourceId,
    super.countryCode,
    super.jurisdictionCode,
    super.updateDate,
    required super.terms,
    super.attrs,
    required super.termsFormatted,
    super.currentPosition,
    required super.memberships,
    super.office,
    required super.polls,
    super.stateName,
  });

  factory PoliticianDetailModel.fromJson(Map<String, dynamic> json) {
    return PoliticianDetailModel(
      id: json['id'] as String,
      bioguideId: json['bioguide_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      middleName: json['middle_name'] as String?,
      suffix: json['suffix'] as String?,
      directOrderName: json['direct_order_name'] as String?,
      invertedOrderName: json['inverted_order_name'] as String?,
      honorificName: json['honorific_name'] as String?,
      party: json['party'] as String,
      state: json['state'] as String,
      district: json['district']?.toString(),
      chamber: json['chamber'] as String,
      birthYear: json['birth_year'] as int?,
      photoUrl: json['photo_url'] as String?,
      officialWebsiteUrl: json['official_website_url'] as String?,
      currentMember: json['current_member'] as bool,
      sponsoredBillCount: json['sponsored_bill_count'] as int? ?? 0,
      cosponsoredBillCount: json['cosponsored_bill_count'] as int? ?? 0,
      level: json['level'] as String,
      source: json['source'] as String?,
      sourceId: json['source_id'] as String?,
      countryCode: json['country_code'] as String?,
      jurisdictionCode: json['jurisdiction_code'] as String?,
      updateDate: json['update_date'] != null ? DateTime.parse(json['update_date']) : null,
      terms: (json['terms'] as List<dynamic>? ?? [])
          .map((e) => Term(
        chamber: e['chamber'] ?? '',
        endYear: e['endYear'] as int?,
        congress: e['congress'] ?? 0,
        district: e['district'] ?? 0,
        startYear: e['startYear'] ?? 0,
        stateCode: e['stateCode'] ?? '',
        stateName: e['stateName'] ?? '',
        memberType: e['memberType'] ?? '',
      ))
          .toList(),
      attrs: json['attrs'] != null
          ? Attributes(
        committees: ((json['attrs']['committees'] ?? []) as List)
            .map((c) => Committee(name: c['name']))
            .toList(),
        leadership: json['attrs']['leadership'] as String?,
        updateDate: json['attrs']['update_date'] != null
            ? DateTime.parse(json['attrs']['update_date'])
            : null,
        partyHistory: ((json['attrs']['party_history'] ?? []) as List)
            .map((p) => PartyHistory(
          partyName: p['partyName'],
          startYear: p['startYear'],
          partyAbbreviation: p['partyAbbreviation'],
        ))
            .toList(),
        sponsoredCount: json['attrs']['sponsored_count'] ?? 0,
        cosponsoredCount: json['attrs']['cosponsored_count'] ?? 0,
        sponsoredLegislation: json['attrs']['sponsored_legislation'] != null
            ? LegislationLink(
          url: json['attrs']['sponsored_legislation']['url'],
          count: json['attrs']['sponsored_legislation']['count'],
        )
            : null,
        cosponsoredLegislation: json['attrs']['cosponsored_legislation'] != null
            ? LegislationLink(
          url: json['attrs']['cosponsored_legislation']['url'],
          count: json['attrs']['cosponsored_legislation']['count'],
        )
            : null,
      )
          : null,
      termsFormatted: (json['terms_formatted'] as List<dynamic>? ?? [])
          .map((e) => TermFormatted(
        chamber: e['chamber'],
        chamberCode: e['chamber_code'],
        position: e['position'],
        state: e['state'],
        stateCode: e['state_code'],
        district: e['district'],
        period: e['period'],
        startYear: e['start_year'],
        endYear: e['end_year'],
        durationYears: e['duration_years'],
        isCurrent: e['is_current'],
        rawData: TermRawData(
          chamber: e['raw_data']['chamber'],
          congress: e['raw_data']['congress'],
          district: e['raw_data']['district'],
          startYear: e['raw_data']['startYear'],
          stateCode: e['raw_data']['stateCode'],
          stateName: e['raw_data']['stateName'],
          memberType: e['raw_data']['memberType'],
          endYear: e['raw_data']['endYear'],
        ),
      ))
          .toList(),
      currentPosition: json['current_position'] != null
          ? CurrentPosition(
        chamber: json['current_position']['chamber'],
        position: json['current_position']['position'],
        state: json['current_position']['state'],
        period: json['current_position']['period'],
      )
          : null,
      memberships: (json['memberships'] as List<dynamic>? ?? [])
          .map((e) => Membership(
        organization: e['organization'],
        role: e['role'],
        postLabel: e['post_label'],
        startDate: e['start_date'],
        endDate: e['end_date'],
      ))
          .toList(),
      office: json['office'] != null
          ? Office(
        address: json['office']['address'],
        city: json['office']['city'],
        state: json['office']['state'],
        district: json['office']['district'],
        zip: json['office']['zip'],
        phone: json['office']['phone'],
        fullAddress: json['office']['full_address'],
      )
          : null,
      polls: (json['polls'] as List<dynamic>? ?? [])
          .map((e) => Poll(
        pollId: e['poll_id'],
        title: e['title'],
        createdAt: DateTime.parse(e['created_at']),
        votesFor: e['votes_for'],
        votesAgainst: e['votes_against'],
        totalVotes: e['total_votes'],
      ))
          .toList(),
      stateName: json['state_name'] as String?,
    );
  }
}
