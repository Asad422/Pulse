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
