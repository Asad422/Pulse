import 'package:pulse/core/network/domain/entities/poll.dart' as core;
import 'package:pulse/core/network/data/models/poll_model.dart' as core_model;

/// Локальная модель Poll для features/politicians
/// Использует core Poll для совместимости
class Poll extends core.Poll {
  final bool? userVote;
  const Poll({
    required super.id,
    required super.title,
    required this.userVote,
    super.politicianId,
    super.politicianBioguideId,
    super.billId,
    super.lawId,
    required super.createdAt,
    required super.votesFor,
    required super.votesAgainst,
    required super.totalVotes,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    // Используем core PollModel для парсинга
    final corePoll = core_model.PollModel.fromJson(json);
    return Poll(
      id: corePoll.id,
      title: corePoll.title,
      politicianId: corePoll.politicianId,
      politicianBioguideId: corePoll.politicianBioguideId,
      billId: corePoll.billId,
      lawId: corePoll.lawId,
      createdAt: corePoll.createdAt,
      votesFor: corePoll.votesFor,
      votesAgainst: corePoll.votesAgainst,
      totalVotes: corePoll.totalVotes,
      userVote: json['user_vote'] as bool?,
    );
  }

  // Для обратной совместимости
  int get pollId => id;
}
