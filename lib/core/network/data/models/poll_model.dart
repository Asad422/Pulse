import '../../domain/entities/poll.dart';

class PollModel extends Poll {
  const PollModel({
    required super.id,
    required super.title,
    super.politicianId,
    super.politicianBioguideId,
    super.billId,
    required super.createdAt,
    required super.votesFor,
    required super.votesAgainst,
    required super.totalVotes,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
      id: json['id'] as int,
      title: json['title'] ?? '',
      politicianId: json['politician_id'] as String?,
      politicianBioguideId: json['politician_bioguide_id'] as String?,
      billId: json['bill_id'] as int?,
      createdAt: DateTime.parse(json['created_at']),
      votesFor: json['votes_for'] as int? ?? 0,
      votesAgainst: json['votes_against'] as int? ?? 0,
      totalVotes: json['total_votes'] as int? ?? 0,
    );
  }
}
