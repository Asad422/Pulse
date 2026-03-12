class Poll {
  final int id;
  final String title;
  final String? politicianId;
  final String? politicianBioguideId;
  final int? billId;
  final int? lawId;
  final DateTime createdAt;
  final int votesFor;
  final int votesAgainst;
  final int totalVotes;

  const Poll({
    required this.id,
    required this.title,
    this.politicianId,
    this.politicianBioguideId,
    this.billId,
    this.lawId,
    required this.createdAt,
    required this.votesFor,
    required this.votesAgainst,
    required this.totalVotes,
  });
}
