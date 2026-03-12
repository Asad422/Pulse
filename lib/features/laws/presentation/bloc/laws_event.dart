part of 'laws_bloc.dart';

abstract class LawsEvent extends Equatable {
  const LawsEvent();
  @override
  List<Object?> get props => [];
}

class LawsRequested extends LawsEvent {
  final LawsQuery query; // ✅ теперь используем единый объект LawsQuery

  const LawsRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class LawsLoadMoreRequested extends LawsEvent {
  const LawsLoadMoreRequested();
}

class LawsVoteSubmitted extends LawsEvent {
  final int pollId;
  final bool choice; // true = support, false = oppose

  const LawsVoteSubmitted({required this.pollId, required this.choice});

  @override
  List<Object?> get props => [pollId, choice];
}

class LawsCancelVoteSubmitted extends LawsEvent {
  final int voteId;
  final int pollId;
  final bool choice; // true = support, false = oppose (какой голос отменяем)
  const LawsCancelVoteSubmitted({
    required this.voteId,
    required this.pollId,
    required this.choice,
  });
  @override
  List<Object?> get props => [voteId, pollId, choice];
}
