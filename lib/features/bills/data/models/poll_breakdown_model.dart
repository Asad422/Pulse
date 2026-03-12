import '../../domain/entities/poll_breakdown.dart';

class CategoryBreakdownModel extends CategoryBreakdown {
  const CategoryBreakdownModel({
    required super.votesFor,
    required super.votesAgainst,
    required super.totalVotes,
    required super.percentFor,
    required super.percentAgainst,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      votesFor: json['votes_for'] as int? ?? 0,
      votesAgainst: json['votes_against'] as int? ?? 0,
      totalVotes: json['total_votes'] as int? ?? 0,
      percentFor: (json['percent_for'] as num?)?.toDouble() ?? 0.0,
      percentAgainst: (json['percent_against'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PollBreakdownModel extends PollBreakdown {
  const PollBreakdownModel({
    required super.pollId,
    required super.totalVotes,
    required super.byAge,
    required super.byGender,
    required super.byLocation,
  });

  factory PollBreakdownModel.fromJson(Map<String, dynamic> json) {
    return PollBreakdownModel(
      pollId: json['poll_id'] as int? ?? 0,
      totalVotes: json['total_votes'] as int? ?? 0,
      byAge: _parseCategory(json['by_age']),
      byGender: _parseCategory(json['by_gender']),
      byLocation: _parseCategory(json['by_location']),
    );
  }

  static Map<String, CategoryBreakdown> _parseCategory(dynamic data) {
    if (data == null || data is! Map) return {};
    
    final result = <String, CategoryBreakdown>{};
    for (final entry in (data as Map<String, dynamic>).entries) {
      if (entry.value is Map<String, dynamic>) {
        result[entry.key] = CategoryBreakdownModel.fromJson(entry.value);
      }
    }
    return result;
  }
}
