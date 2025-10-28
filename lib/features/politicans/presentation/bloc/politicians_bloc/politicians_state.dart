part of 'politicians_bloc.dart';

enum PoliticiansStatus { initial, loading, success, failure, loadingMore }

class PoliticiansState extends Equatable {
  final PoliticiansStatus status;
  final List<Politician> items;
  final String? error;
  final bool hasReachedEnd;
  final PoliticiansQuery? query;
  final _VoteInfo? voteJustSent; // 🧩 информация о последнем голосовании

  const PoliticiansState({
    required this.status,
    required this.items,
    this.error,
    this.hasReachedEnd = false,
    this.query,
    this.voteJustSent,
  });

  const PoliticiansState.initial()
      : status = PoliticiansStatus.initial,
        items = const [],
        error = null,
        hasReachedEnd = false,
        query = null,
        voteJustSent = null;

  PoliticiansState copyWith({
    PoliticiansStatus? status,
    List<Politician>? items,
    String? error,
    bool? hasReachedEnd,
    PoliticiansQuery? query,
    _VoteInfo? voteJustSent,
  }) {
    return PoliticiansState(
      status: status ?? this.status,
      items: items != null
          ? List<Politician>.from(items)
          : List<Politician>.from(this.items),
      error: error,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      query: query ?? this.query,
      voteJustSent: voteJustSent,
    );
  }

  @override
  List<Object?> get props =>
      [status, items, error, hasReachedEnd, query, voteJustSent];
}

/// внутренний объект — данные о голосовании (для SnackBar)
class _VoteInfo extends Equatable {
  final int pollId;
  final bool choice;
  const _VoteInfo({
    required this.pollId,
    required this.choice,
  });

  @override
  List<Object?> get props => [pollId, choice];
}
