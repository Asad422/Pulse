import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/bill.dart';
import '../../domain/usecases/get_bills_usecase.dart';

part 'bills_event.dart';
part 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final GetBillsUseCase _getBills;

  BillsBloc(this._getBills) : super(const BillsState.initial()) {
    on<BillsRequested>(_onRequested);
  }

  Future<void> _onRequested(
      BillsRequested event,
      Emitter<BillsState> emit,
      ) async {
    emit(state.copyWith(status: BillsStatus.loading));
    try {
      final bills = await _getBills(skip: event.skip, limit: event.limit);
      emit(state.copyWith(status: BillsStatus.success, items: bills));
    } catch (e) {
      emit(state.copyWith(status: BillsStatus.failure, error: e.toString()));
    }
  }
}
