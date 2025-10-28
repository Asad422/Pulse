class Vote {
  final int id;
  final int pollId;
  final int userId;
  final bool choice;
  final DateTime votedAt;

  const Vote({
    required this.id,
    required this.pollId,
    required this.userId,
    required this.choice,
    required this.votedAt,
  });
}
