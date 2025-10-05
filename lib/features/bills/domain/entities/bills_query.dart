class BillsQuery {
  final int skip;
  final int limit;
  final String? status;
  final String? level;
  final bool? isFeatured;
  final String? q; // search query
  final String? introducedFrom; // YYYY-MM-DD
  final String? introducedTo; // YYYY-MM-DD
  final String? subject;
  final String? committee;
  final String? sponsor;
  final String? sortBy; // last_updated | introduced_date | title
  final String? order; // asc | desc

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
}
