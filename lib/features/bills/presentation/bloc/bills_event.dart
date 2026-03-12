part of 'bills_bloc.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();
  @override
  List<Object?> get props => [];
}

class BillsRequested extends BillsEvent {
  final BillsQuery query;
  const BillsRequested({required this.query});
  @override
  List<Object?> get props => [query];
}

class BillsLoadMoreRequested extends BillsEvent {
  const BillsLoadMoreRequested();
}

class BillsVoteSubmitted extends BillsEvent {
  final int pollId;
  final bool choice; // true = support, false = oppose

  const BillsVoteSubmitted({required this.pollId, required this.choice});

  @override
  List<Object?> get props => [pollId, choice];
}

class BillsCancelVoteSubmitted extends BillsEvent {
  final int voteId;
  final int pollId;
  final bool choice; // true = support, false = oppose (какой голос отменяем)
  const BillsCancelVoteSubmitted({
    required this.voteId,
    required this.pollId,
    required this.choice,
  });
  @override
  List<Object?> get props => [voteId, pollId, choice];
}