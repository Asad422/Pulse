import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/bill.dart';
import '../../domain/usecases/get_bill_usecase.dart';

part 'bill_detail_event.dart';
part 'bill_detail_state.dart';

class BillDetailBloc extends Bloc<BillDetailEvent, BillDetailState> {
  final GetBillUseCase _getBill;

  BillDetailBloc(this._getBill) : super(const BillDetailState.initial()) {
    on<BillDetailRequested>(_onRequested);
  }

  Future<void> _onRequested(
      BillDetailRequested event,
      Emitter<BillDetailState> emit,
      ) async {
    emit(state.copyWith(status: BillDetailStatus.loading));
    try {
      final bill = await _getBill(event.billId);
      emit(state.copyWith(status: BillDetailStatus.success, bill: bill));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(
        status: BillDetailStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
