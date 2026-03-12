import '../../domain/entities/law.dart';
import '../../../../core/network/data/models/poll_model.dart';

class LawModel extends Law {
  const LawModel({
    required super.id,
    required super.congress,
    required super.lawType,
    required super.lawNumber,
    required super.title,
    required super.url,
    required super.enactedDate,
    super.pollStats,
    super.userVote,
    super.billIds,
  });

  factory LawModel.fromJson(Map<String, dynamic> json) {
    return LawModel(
      id: json['id'] as int? ?? 0,
      congress: json['congress'] as int? ?? 0,
      lawType: json['law_type'] as String? ?? '',
      lawNumber: json['law_number'] as String? ?? '',
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      enactedDate: DateTime.tryParse(json['enacted_date'] ?? '') ?? DateTime(1970),
      pollStats: json['poll_stats'] != null
          ? PollModel.fromJson(json['poll_stats'] as Map<String, dynamic>)
          : null,
      userVote: json['user_vote'] as bool?,
      billIds: (json['bill_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? [],
    );
  }
}
