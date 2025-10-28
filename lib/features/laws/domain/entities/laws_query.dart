class LawsQuery {
  final int skip;
  final int limit;
  final int? congress;
  final String? lawType;
  final String? lawNumber;
  final int? billId;
  final String? level;
  final String? q; // поиск по тексту или названию закона
  final String? introducedFrom;
  final String? introducedTo;
  final String? sortBy; // например: introduced_date, last_updated
  final String? order; // asc, desc

  const LawsQuery({
    this.skip = 0,
    this.limit = 20,
    this.congress,
    this.lawType,
    this.lawNumber,
    this.billId,
    this.level,
    this.q,
    this.introducedFrom,
    this.introducedTo,
    this.sortBy,
    this.order,
  });

  LawsQuery copyWith({
    int? skip,
    int? limit,
    int? congress,
    String? lawType,
    String? lawNumber,
    int? billId,
    String? level,
    String? q,
    String? introducedFrom,
    String? introducedTo,
    String? sortBy,
    String? order,
  }) {
    return LawsQuery(
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      congress: congress ?? this.congress,
      lawType: lawType ?? this.lawType,
      lawNumber: lawNumber ?? this.lawNumber,
      billId: billId ?? this.billId,
      level: level ?? this.level,
      q: q ?? this.q,
      introducedFrom: introducedFrom ?? this.introducedFrom,
      introducedTo: introducedTo ?? this.introducedTo,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }
}
