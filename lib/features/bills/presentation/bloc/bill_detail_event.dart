part of 'bill_detail_bloc.dart';

abstract class BillDetailEvent extends Equatable {
  const BillDetailEvent();
  @override
  List<Object?> get props => [];
}

class BillDetailRequested extends BillDetailEvent {
  final String billId;
  const BillDetailRequested(this.billId);

  @override
  List<Object?> get props => [billId];
}
