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
