class PoliticiansQuery {
  final int skip;
  final int limit;
  final String? level; // federal/state/local
  final String? state;
  final String? party;
  final int? congress;
  final String? chamber; // house/senate
  final bool currentOnly;
  final String? q; // search query

  const PoliticiansQuery({
    this.skip = 0,
    this.limit = 20,
    this.level,
    this.state,
    this.party,
    this.congress,
    this.chamber,
    this.currentOnly = true,
    this.q,
  });

  PoliticiansQuery copyWith({
    int? skip,
    int? limit,
    String? level,
    String? state,
    String? party,
    int? congress,
    String? chamber,
    bool? currentOnly,
    String? q,
  }) {
    return PoliticiansQuery(
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      level: level ?? this.level,
      state: state ?? this.state,
      party: party ?? this.party,
      congress: congress ?? this.congress,
      chamber: chamber ?? this.chamber,
      currentOnly: currentOnly ?? this.currentOnly,
      q: q ?? this.q,
    );
  }
}
