import '../../../../core/network/domain/entities/poll.dart';

class Law {
  final int id;
  final int congress;
  final String lawType;
  final String lawNumber;
  final String title;
  final String url;
  final DateTime enactedDate;
  final Poll? pollStats;
  /// true = user voted "support", false = user voted "oppose", null = no vote
  final bool? userVote;
  /// IDs связанных bills
  final List<int> billIds;

  const Law({
    required this.id,
    required this.congress,
    required this.lawType,
    required this.lawNumber,
    required this.title,
    required this.url,
    required this.enactedDate,
    this.pollStats,
    this.userVote,
    this.billIds = const [],
  });
}
