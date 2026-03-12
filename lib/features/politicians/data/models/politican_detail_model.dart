import '../../domain/entities/politican_detail.dart';
import 'poll_model.dart';

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
    super.sex,
    super.photoUrl,
    super.photoAttribution,
    super.officialWebsiteUrl,
    required super.currentMember,
    required super.sponsoredBillCount,
    required super.cosponsoredBillCount,
    required super.level,
    super.source,
    super.sourceId,
    super.countryCode,
    super.jurisdictionCode,
    super.congressUrl,
    super.updateDate,
    required super.terms,
    super.attrs,
    required super.termsFormatted,
    super.currentPosition,
    required super.memberships,
    super.office,
    super.contact,
    required super.polls,
    super.stateName,
    super.leadership,
    super.partyHistory,
    super.depictionAttribution,
    super.sponsoredCount,
    super.cosponsoredCount,
    super.depiction,
  });

  factory PoliticianDetailModel.fromJson(Map<String, dynamic> json) {
    // === helpers ===
    int? _asInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '');
    bool? _asBool(dynamic v) {
      if (v is bool) return v;
      if (v == null) return null;
      final s = v.toString().toLowerCase();
      if (s == 'true') return true;
      if (s == 'false') return false;
      return null;
    }

    List<TermFormatted> _parseTermFormatted(List list) {
      return list.map((e) {
        final raw = e['raw_data'] as Map<String, dynamic>? ?? const {};
        return TermFormatted(
          chamber: (e['chamber'] ?? '') as String,
          chamberCode: (e['chamber_code'] ?? '') as String,
          position: (e['position'] ?? '') as String,
          state: (e['state'] ?? '') as String,
          stateCode: (e['state_code'] ?? '') as String,
          district: _asInt(e['district']) ?? 0,
          period: (e['period'] ?? '') as String,
          startYear: _asInt(e['start_year']) ?? 0,
          endYear: _asInt(e['end_year']),
          durationYears: _asInt(e['duration_years']) ?? 0,
          isCurrent: _asBool(e['is_current']) ?? false,
          rawData: TermRawData(
            chamber: (raw['chamber'] ?? '') as String,
            congress: _asInt(raw['congress']) ?? 0,
            district: _asInt(raw['district']) ?? 0,
            startYear: _asInt(raw['startYear']) ?? 0,
            stateCode: (raw['stateCode'] ?? '') as String,
            stateName: (raw['stateName'] ?? '') as String,
            memberType: (raw['memberType'] ?? '') as String,
            endYear: _asInt(raw['endYear']),
          ),
        );
      }).toList();
    }

    List<Committee> _parseCommittees(dynamic v) {
      final list = (v as List?) ?? const [];
      return list.map((item) {
        if (item is String) return Committee(name: item);
        if (item is Map<String, dynamic>) {
          return Committee(name: item['name'] as String?);
        }
        return const Committee(name: null);
      }).toList();
    }

    final attrsMap = json['attrs'] as Map<String, dynamic>?;
    final termHistory =
        (json['term_history'] as List?) ??
            (json['terms_formatted'] as List?) ??
            const [];

    // === main factory ===
    return PoliticianDetailModel(
      id: (json['id'] ?? json['politician_id']) as String,
      bioguideId: (json['bioguide_id'] ?? '') as String,
      firstName: (json['first_name'] ?? '') as String,
      lastName: (json['last_name'] ?? '') as String,
      middleName: json['middle_name'] as String?,
      suffix: json['suffix'] as String?,
      directOrderName: json['direct_order_name'] as String?,
      invertedOrderName: json['inverted_order_name'] as String?,
      honorificName: json['honorific_name'] as String?,
      party: (json['party'] ?? '') as String,
      state: (json['state'] ?? '') as String,
      district: json['district']?.toString(),
      chamber: (json['chamber'] ?? '') as String,
      birthYear: _asInt(json['birth_year']),
      sex: json['sex'] as String?,
      photoUrl: json['photo_url'] as String?,
      photoAttribution: json['photo_attribution'] as String?,
      officialWebsiteUrl: json['official_website_url'] as String?,
      currentMember: _asBool(json['current_member']) ?? false,
      sponsoredBillCount: _asInt(json['sponsored_bill_count']) ?? 0,
      cosponsoredBillCount: _asInt(json['cosponsored_bill_count']) ?? 0,
      level: (json['level'] ?? '') as String,
      source: json['source'] as String?,
      sourceId: json['source_id'] as String?,
      countryCode: json['country_code'] as String?,
      jurisdictionCode: json['jurisdiction_code'] as String?,
      congressUrl: json['congress_url'] as String?,
      updateDate: json['update_date'] != null
          ? DateTime.tryParse(json['update_date'] as String)
          : null,

      // --- terms ---
      terms: (json['terms'] as List<dynamic>? ?? [])
          .map((e) => Term(
        chamber: (e['chamber'] ?? '') as String,
        endYear: _asInt(e['endYear']),
        congress: _asInt(e['congress']) ?? 0,
        district: _asInt(e['district']) ?? 0,
        startYear: _asInt(e['startYear']) ?? 0,
        stateCode: (e['stateCode'] ?? '') as String,
        stateName: (e['stateName'] ?? '') as String,
        memberType: (e['memberType'] ?? '') as String,
      ))
          .toList(),

      // --- attrs ---
      attrs: attrsMap != null
          ? Attributes(
        committees: _parseCommittees(attrsMap['committees']),
        leadership: attrsMap['leadership'] as String?,
        updateDate: attrsMap['update_date'] != null
            ? DateTime.tryParse(attrsMap['update_date'] as String)
            : null,
        partyHistory: ((attrsMap['party_history'] as List?) ?? const [])
            .map((p) => PartyHistory(
          partyName: (p['partyName'] ?? '') as String,
          startYear: _asInt(p['startYear']) ?? 0,
          partyAbbreviation:
          (p['partyAbbreviation'] ?? '') as String,
        ))
            .toList(),
        sponsoredCount: _asInt(attrsMap['sponsored_count']) ?? 0,
        cosponsoredCount: _asInt(attrsMap['cosponsored_count']) ?? 0,
        sponsoredLegislation: attrsMap['sponsored_legislation'] != null
            ? LegislationLink(
          url: (attrsMap['sponsored_legislation']['url'] ?? '')
          as String,
          count: _asInt(
              attrsMap['sponsored_legislation']['count']) ??
              0,
        )
            : null,
        cosponsoredLegislation: attrsMap['cosponsored_legislation'] !=
            null
            ? LegislationLink(
          url: (attrsMap['cosponsored_legislation']['url'] ?? '')
          as String,
          count: _asInt(
              attrsMap['cosponsored_legislation']['count']) ??
              0,
        )
            : null,
      )
          : null,

      // --- termsFormatted (term_history) ---
      termsFormatted: _parseTermFormatted(termHistory as List),

      // --- current_position ---
      currentPosition: _parseCurrentPosition(json['current_position'], _asInt, _asBool),

      // --- memberships ---
      memberships: (json['memberships'] as List<dynamic>? ?? [])
          .map((e) => Membership(
        organization: (e['organization'] ?? '') as String,
        role: (e['role'] ?? '') as String,
        postLabel: (e['post_label'] ?? '') as String,
        startDate: (e['start_date'] ?? '') as String,
        endDate: e['end_date'] as String?,
      ))
          .toList(),

      // --- office (legacy) ---
      office: (json['office'] != null)
          ? Office(
        address: (json['office']['address'] ?? '') as String,
        city: (json['office']['city'] ?? '') as String,
        state: (json['office']['state'] ?? '') as String,
        district: (json['office']['district'] ?? '') as String,
        zip: (json['office']['zip'] ?? '') as String,
        phone: (json['office']['phone'] ?? '') as String,
        fullAddress: (json['office']['full_address'] ?? '') as String,
      )
          : null,

      // --- contact ---
      contact: (json['contact'] != null)
          ? Contact(
        address: json['contact']['address'] as String?,
        city: json['contact']['city'] as String?,
        state: json['contact']['state'] as String?,
        district: json['contact']['district'] as String?,
        zip: json['contact']['zip'] as String?,
        phone: json['contact']['phone'] as String?,
        fullAddress: json['contact']['full_address'] as String?,
      )
          : null,

      // --- polls ---
      polls: (json['polls'] as List<dynamic>? ?? [])
          .map((e) => Poll.fromJson(e as Map<String, dynamic>))
          .toList(),

      // --- meta ---
      stateName: json['state_name'] as String?,
      leadership: json['leadership'] as String?,
      partyHistory: ((json['party_history'] as List?) ?? const [])
          .map((p) => PartyHistory(
        partyName: (p['partyName'] ?? '') as String,
        startYear: _asInt(p['startYear']) ?? 0,
        partyAbbreviation: (p['partyAbbreviation'] ?? '') as String,
      ))
          .toList(),
      depictionAttribution: json['depiction_attribution'] as String?,
      sponsoredCount: _asInt(json['sponsored_count']),
      cosponsoredCount: _asInt(json['cosponsored_count']),
      depiction: json['depiction']?.toString(),
    );
  }

  /// --- Helper для безопасного парсинга current_position ---
  static CurrentPosition? _parseCurrentPosition(
      dynamic value,
      int? Function(dynamic) _asInt,
      bool? Function(dynamic) _asBool) {
    if (value is! Map<String, dynamic>) return null;
    final cp = value;
    final raw =
    cp['raw_data'] is Map<String, dynamic> ? cp['raw_data'] as Map<String, dynamic> : null;

    return CurrentPosition(
      chamber: cp['chamber'] as String?,
      chamberCode: cp['chamber_code'] as String?,
      position: cp['position'] as String?,
      state: cp['state'] as String?,
      stateCode: cp['state_code'] as String?,
      district: _asInt(cp['district']),
      period: cp['period'] as String?,
      startYear: _asInt(cp['start_year']),
      endYear: _asInt(cp['end_year']),
      durationYears: _asInt(cp['duration_years']),
      isCurrent: _asBool(cp['is_current']),
      rawData: raw != null
          ? RawPositionData(
        chamber: raw['chamber'] as String?,
        congress: _asInt(raw['congress']),
        district: _asInt(raw['district']),
        startYear: _asInt(raw['startYear']),
        stateCode: raw['stateCode'] as String?,
        stateName: raw['stateName'] as String?,
        memberType: raw['memberType'] as String?,
        endYear: _asInt(raw['endYear']),
      )
          : null,
    );
  }
}
