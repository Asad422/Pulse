part of 'bills_bloc.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();
  @override
  List<Object?> get props => [];
}

class BillsRequested extends BillsEvent {
  final int skip;
  final int limit;
  const BillsRequested({this.skip = 0, this.limit = 20});
}
