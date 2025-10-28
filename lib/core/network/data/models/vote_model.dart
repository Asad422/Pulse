import '../../domain/entities/vote.dart';

class VoteModel extends Vote {
  const VoteModel({
    required super.id,
    required super.pollId,
    required super.userId,
    required super.choice,
    required super.votedAt,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      id: json['id'] as int,
      pollId: json['poll_id'] as int,
      userId: json['user_id'] as int,
      choice: json['choice'] as bool,
      votedAt: DateTime.parse(json['voted_at']),
    );
  }
}
