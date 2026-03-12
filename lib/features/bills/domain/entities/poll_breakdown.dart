/// Статистика голосования по одной категории (возраст, пол, локация)
class CategoryBreakdown {
  final int votesFor;
  final int votesAgainst;
  final int totalVotes;
  final double percentFor;
  final double percentAgainst;

  const CategoryBreakdown({
    required this.votesFor,
    required this.votesAgainst,
    required this.totalVotes,
    required this.percentFor,
    required this.percentAgainst,
  });
}

/// Полный breakdown голосования
class PollBreakdown {
  final int pollId;
  final int totalVotes;
  final Map<String, CategoryBreakdown> byAge;
  final Map<String, CategoryBreakdown> byGender;
  final Map<String, CategoryBreakdown> byLocation;

  const PollBreakdown({
    required this.pollId,
    required this.totalVotes,
    required this.byAge,
    required this.byGender,
    required this.byLocation,
  });
}
