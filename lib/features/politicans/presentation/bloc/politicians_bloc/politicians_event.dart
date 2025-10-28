part of 'politicians_bloc.dart';

abstract class PoliticiansEvent extends Equatable {
  const PoliticiansEvent();
  @override
  List<Object?> get props => [];
}

class PoliticiansLoadRequested extends PoliticiansEvent {
  final PoliticiansQuery query;
  const PoliticiansLoadRequested(this.query);
  @override
  List<Object?> get props => [query];
}

class PoliticiansLoadMoreRequested extends PoliticiansEvent {
  const PoliticiansLoadMoreRequested();
}
class PoliticianVoteSubmitted extends PoliticiansEvent {
  final int pollId;
  final bool choice; // true = за, false = против
  const PoliticianVoteSubmitted({
    required this.pollId,
    required this.choice,
  });

  @override
  List<Object?> get props => [pollId, choice];
}
