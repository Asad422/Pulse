part of 'bills_bloc.dart';

enum BillsStatus { initial, loading, success, failure, loadingMore }

class BillsState extends AppState {
  final BillsStatus status;
  final List<Bill> items;
  final bool hasReachedEnd;
  final BillsQuery? query;
  final bool isVoting;
  final int? votingPollId;
  final bool? votingChoice; // true = support, false = oppose

  const BillsState({
    required this.status,
    required this.items,
    super.failure,
    this.hasReachedEnd = false,
    this.query,
    this.isVoting = false,
    this.votingPollId,
    this.votingChoice,
  });

  const BillsState.initial()
      : status = BillsStatus.initial,
        items = const [],
        hasReachedEnd = false,
        query = null,
        isVoting = false,
        votingPollId = null,
        votingChoice = null,
        super(failure: null);

  BillsState copyWith({
    BillsStatus? status,
    List<Bill>? items,
    Failure? failure,
    bool clearFailure = false,
    bool? hasReachedEnd,
    BillsQuery? query,
    bool? isVoting,
    int? votingPollId,
    bool? votingChoice,
  }) {
    return BillsState(
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
  List<Object?> get props =>
      [...super.props, status, items, hasReachedEnd, query, isVoting, votingPollId, votingChoice];
}
