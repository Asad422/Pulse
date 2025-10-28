part of 'bills_bloc.dart';

enum BillsStatus { initial, loading, success, failure, loadingMore }

class BillsState extends Equatable {
  final BillsStatus status;
  final List<Bill> items;
  final String? error;
  final bool hasReachedEnd;
  final BillsQuery? query;

  const BillsState({
    required this.status,
    required this.items,
    this.error,
    this.hasReachedEnd = false,
    this.query,
  });

  const BillsState.initial()
      : status = BillsStatus.initial,
        items = const [],
        error = null,
        hasReachedEnd = false,
        query = null;

  BillsState copyWith({
    BillsStatus? status,
    List<Bill>? items,
    String? error,
    bool? hasReachedEnd,
    BillsQuery? query,
  }) {
    return BillsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [status, items, error, hasReachedEnd, query];
}
