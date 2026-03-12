import '../../domain/entities/poll.dart';

class PollModel extends Poll {
  const PollModel({
    required super.id,
    required super.title,
    super.politicianId,
    super.politicianBioguideId,
    super.billId,
    super.lawId,
    required super.createdAt,
    required super.votesFor,
    required super.votesAgainst,
    required super.totalVotes,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) {
    // Поддерживаем как 'id', так и 'poll_id'
    final pollId = json['poll_id'] as int? ?? json['id'] as int? ?? 0;
    
    return PollModel(
      id: pollId,
      title: json['title'] ?? '',
      politicianId: json['politician_id'] as String?,
      politicianBioguideId: json['politician_bioguide_id'] as String?,
      billId: json['bill_id'] as int?,
      lawId: json['law_id'] as int?,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      votesFor: json['votes_for'] as int? ?? 0,
      votesAgainst: json['votes_against'] as int? ?? 0,
      totalVotes: json['total_votes'] as int? ?? 0,
    );
  }
}
