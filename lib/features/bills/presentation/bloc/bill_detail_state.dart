part of 'bill_detail_bloc.dart';

enum BillDetailStatus { initial, loading, success, failure }

class BillDetailState extends Equatable {
  final BillDetailStatus status;
  final Bill? bill;
  final String? error;

  const BillDetailState({
    required this.status,
    this.bill,
    this.error,
  });

  const BillDetailState.initial()
      : status = BillDetailStatus.initial,
        bill = null,
        error = null;

  BillDetailState copyWith({
    BillDetailStatus? status,
    Bill? bill,
    String? error,
  }) {
    return BillDetailState(
      status: status ?? this.status,
      bill: bill ?? this.bill,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, bill, error];
}
