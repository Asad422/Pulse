import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bills_query.dart';
import '../../domain/usecases/get_bills_usecase.dart';

part 'bills_event.dart';
part 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final GetBillsUseCase _getBills;
  BillsBloc(this._getBills) : super(const BillsState.initial()) {
    on<BillsRequested>(_onRequested);
    on<BillsLoadMoreRequested>(_onLoadMore);
  }

  static const _pageSize = 20;

  Future<void> _onRequested(
      BillsRequested event,
      Emitter<BillsState> emit,
      ) async {
    emit(state.copyWith(status: BillsStatus.loading, hasReachedEnd: false));
    try {
      final bills = await _getBills(event.query);
      emit(state.copyWith(
        status: BillsStatus.success,
        items: bills,
        query: event.query,
        hasReachedEnd: bills.length < event.query.limit,
      ));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(status: BillsStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onLoadMore(
      BillsLoadMoreRequested event,
      Emitter<BillsState> emit,
      ) async {
    if (state.hasReachedEnd || state.status == BillsStatus.loadingMore) return;

    emit(state.copyWith(status: BillsStatus.loadingMore));
    try {
      final nextSkip = state.items.length;
      final nextQuery = BillsQuery(
        skip: nextSkip,
        limit: _pageSize,
        level: state.query?.level,
        q: state.query?.q,
        sortBy: state.query?.sortBy,
        order: state.query?.order,
      );

      final bills = await _getBills(nextQuery);

      if (bills.isEmpty) {
        emit(state.copyWith(hasReachedEnd: true, status: BillsStatus.success));
      } else {
        emit(state.copyWith(
          status: BillsStatus.success,
          items: List.of(state.items)..addAll(bills),
          hasReachedEnd: bills.length < _pageSize,
        ));
      }
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(status: BillsStatus.failure, error: e.toString()));
    }
  }
}
