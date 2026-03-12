part of 'politicians_bloc.dart';

enum PoliticiansStatus { initial, loading, success, failure, loadingMore }

class PoliticiansState extends AppState {
  final PoliticiansStatus status;
  final List<Politician> items;
  final bool hasReachedEnd;
  final PoliticiansQuery? query;
  final bool isVoting;
  final int? votingPollId;
  final bool? votingChoice; // true = approve, false = disapprove

  const PoliticiansState({
    required this.status,
    required this.items,
    super.failure,
    this.hasReachedEnd = false,
    this.query,
    this.isVoting = false,
    this.votingPollId,
    this.votingChoice,
  });

  const PoliticiansState.initial()
      : status = PoliticiansStatus.initial,
        items = const [],
        hasReachedEnd = false,
        query = null,
        isVoting = false,
        votingPollId = null,
        votingChoice = null,
        super(failure: null);

  PoliticiansState copyWith({
    PoliticiansStatus? status,
    List<Politician>? items,
    Failure? failure,
    bool clearFailure = false,
    bool? hasReachedEnd,
    PoliticiansQuery? query,
    bool? isVoting,
    int? votingPollId,
    bool? votingChoice,
  }) {
    return PoliticiansState(
      status: status ?? this.status,
      items: items != null
          ? List<Politician>.from(items)
          : List<Politician>.from(this.items),
      failure: clearFailure ? null : (failure ?? this.failure),
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      query: query ?? this.query,
      isVoting: isVoting ?? this.isVoting,
      votingPollId: votingPollId,
      votingChoice: votingChoice,
    );
  }

  @override
  List<Object?> get props =>
      [...super.props, status, items, hasReachedEnd, query, isVoting, votingPollId, votingChoice];
}

