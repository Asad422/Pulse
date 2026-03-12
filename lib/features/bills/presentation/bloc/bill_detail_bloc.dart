import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import 'package:pulse/features/bills/domain/usecases/get_bill_amendments_usecase.dart';
import 'package:pulse/features/bills/domain/usecases/get_poll_breakdown.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_amendment.dart';
import '../../domain/entities/poll_breakdown.dart';
import '../../domain/usecases/get_bill_usecase.dart';

part 'bill_detail_event.dart';
part 'bill_detail_state.dart';

class BillDetailBloc extends Bloc<BillDetailEvent, BillDetailState> {
  final GetBillUseCase _getBill;
  final GetPollBreakdown _getPollBreakdown;
  final GetBillAmendmentsUseCase _getAmendments;

  BillDetailBloc(
    this._getBill,
    this._getAmendments,
    this._getPollBreakdown,
  ) : super(const BillDetailState.initial()) {
    on<BillDetailRequested>(_onRequested);
    on<BillDetailRefreshRequested>(_onRefreshRequested);
    on<BillDetailAmendmentsRequested>(_onAmendmentsRequested);
    on<PollBreakDownRequested>(_onPollBreakDownRequested);
  }

  Future<void> _onRequested(
    BillDetailRequested event,
    Emitter<BillDetailState> emit,
  ) async {
    emit(state.copyWith(status: BillDetailStatus.loading, clearFailure: true));

    final result = await _getBill(event.billId);
    result.fold(
      (failure) => emit(state.copyWith(status: BillDetailStatus.failure, failure: failure)),
      (bill) => emit(state.copyWith(status: BillDetailStatus.success, bill: bill)),
    );
  }

  Future<void> _onRefreshRequested(
    BillDetailRefreshRequested event,
    Emitter<BillDetailState> emit,
  ) async {
    final result = await _getBill(event.billId);
    result.fold(
      (failure) => addError(failure),
      (bill) => emit(state.copyWith(bill: bill)),
    );
  }

  Future<void> _onAmendmentsRequested(
    BillDetailAmendmentsRequested event,
    Emitter<BillDetailState> emit,
  ) async {
    emit(state.copyWith(amendmentsStatus: AmendmentsStatus.loading));

    final result = await _getAmendments(event.billId);
    result.fold(
      (failure) => emit(state.copyWith(amendmentsStatus: AmendmentsStatus.failure)),
      (amendments) => emit(state.copyWith(
        amendmentsStatus: AmendmentsStatus.success,
        amendments: amendments,
      )),
    );
  }

  Future<void> _onPollBreakDownRequested(
    PollBreakDownRequested event,
    Emitter<BillDetailState> emit,
  ) async {
    emit(state.copyWith(pollBreakdownStatus: PollBreakdownStatus.loading));

    final result = await _getPollBreakdown(event.pollId);
    result.fold(
      (failure) => emit(state.copyWith(pollBreakdownStatus: PollBreakdownStatus.failure)),
      (breakdown) => emit(state.copyWith(
        pollBreakdownStatus: PollBreakdownStatus.success,
        pollBreakdown: breakdown,
      )),
    );
  }
}
