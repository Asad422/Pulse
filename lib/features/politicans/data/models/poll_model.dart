class Poll {
  final int pollId;
  final String title;
  final String createdAt;
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

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      pollId: json['poll_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      votesFor: json['votes_for'] as int? ?? 0,
      votesAgainst: json['votes_against'] as int? ?? 0,
      totalVotes: json['total_votes'] as int? ?? 0,
    );
  }
}
