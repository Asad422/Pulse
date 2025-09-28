part of 'bills_bloc.dart';

enum BillsStatus { initial, loading, success, failure }

class BillsState extends Equatable {
  final BillsStatus status;
  final List<Bill> items;
  final String? error;

  const BillsState({
    required this.status,
    this.items = const [],
    this.error,
  });

  const BillsState.initial()
      : status = BillsStatus.initial,
        items = const [],
        error = null;

  BillsState copyWith({
    BillsStatus? status,
    List<Bill>? items,
    String? error,
  }) {
    return BillsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
