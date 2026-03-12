part of 'laws_bloc.dart';

enum LawsStatus { initial, loading, success, failure, loadingMore }

class LawsState extends AppState {
  final LawsStatus status;
  final List<Law> items;
  final bool hasReachedEnd;
  final LawsQuery? query;
  final bool isVoting;
  final int? votingPollId;
  final bool? votingChoice;

  const LawsState({
    required this.status,
    this.items = const [],
    super.failure,
    this.hasReachedEnd = false,
    this.query,
    this.isVoting = false,
    this.votingPollId,
    this.votingChoice,
  });

  const LawsState.initial()
      : status = LawsStatus.initial,
        items = const [],
        hasReachedEnd = false,
        query = null,
        isVoting = false,
        votingPollId = null,
        votingChoice = null,
        super(failure: null);

  LawsState copyWith({
    LawsStatus? status,
    List<Law>? items,
    Failure? failure,
    bool clearFailure = false,
    bool? hasReachedEnd,
    LawsQuery? query,
    bool? isVoting,
    int? votingPollId,
    bool? votingChoice,
  }) {
    return LawsState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: clearFailure ? null : (failure ?? this.failure),
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      query: query ?? this.query,
      isVoting: isVoting ?? this.isVoting,
      votingPollId: votingPollId ?? this.votingPollId,
      votingChoice: votingChoice ?? this.votingChoice,
    );
  }

  @override
  List<Object?> get props => [...super.props, status, items, hasReachedEnd, query, isVoting, votingPollId, votingChoice];
}
