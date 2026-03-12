class BillsQuery {
  final int skip;
  final int limit;
  final String? status;
  final String? level;
  final bool? isFeatured;
  final String? q;
  final String? introducedFrom;
  final String? introducedTo;
  final String? subject;
  final String? committee;
  final String? sponsor;
  final String? sortBy;
  final String? order;

  const BillsQuery({
    this.skip = 0,
    this.limit = 20,
    this.status,
    this.level,
    this.isFeatured,
    this.q,
    this.introducedFrom,
    this.introducedTo,
    this.subject,
    this.committee,
    this.sponsor,
    this.sortBy,
    this.order,
  });

  BillsQuery copyWith({
    int? skip,
    int? limit,
    String? status,
    String? level,
    bool? isFeatured,
    String? q,
    String? introducedFrom,
    String? introducedTo,
    String? subject,
    String? committee,
    String? sponsor,
    String? sortBy,
    String? order,
  }) {
    return BillsQuery(
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      status: status ?? this.status,
      level: level ?? this.level,
      isFeatured: isFeatured ?? this.isFeatured,
      q: q ?? this.q,
      introducedFrom: introducedFrom ?? this.introducedFrom,
      introducedTo: introducedTo ?? this.introducedTo,
      subject: subject ?? this.subject,
      committee: committee ?? this.committee,
      sponsor: sponsor ?? this.sponsor,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }
}
