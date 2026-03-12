import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';

import '../../domain/entities/law.dart';
import '../../domain/usecases/get_law_usecase.dart';
import '../../domain/usecases/get_law_poll_breakdown_usecase.dart';
import '../../domain/usecases/get_law_related_bills_usecase.dart';

part 'law_detail_event.dart';
part 'law_detail_state.dart';

class LawDetailBloc extends Bloc<LawDetailEvent, LawDetailState> {
  final GetLawUseCase _getLaw;
  final GetLawPollBreakdownUseCase _getPollBreakdown;
  final GetLawRelatedBillsUseCase _getRelatedBills;

  LawDetailBloc(this._getLaw, this._getPollBreakdown, this._getRelatedBills)
      : super(const LawDetailState.initial()) {
    on<LawDetailRequested>(_onRequested);
    on<LawDetailRefreshRequested>(_onRefreshRequested);
    on<LawPollBreakDownRequested>(_onPollBreakDownRequested);
    on<LawRelatedBillsRequested>(_onRelatedBillsRequested);
  }

  Future<void> _onRequested(
    LawDetailRequested event,
    Emitter<LawDetailState> emit,
  ) async {
    emit(state.copyWith(status: LawDetailStatus.loading, clearFailure: true));

    final result = await _getLaw(event.lawId);
    result.fold(
      (failure) => emit(state.copyWith(status: LawDetailStatus.failure, failure: failure)),
      (law) => emit(state.copyWith(status: LawDetailStatus.success, law: law)),
    );
  }

  Future<void> _onRefreshRequested(
    LawDetailRefreshRequested event,
    Emitter<LawDetailState> emit,
  ) async {
    final result = await _getLaw(event.lawId);
    result.fold(
      (failure) => addError(failure),
      (law) => emit(state.copyWith(law: law)),
    );
  }

  Future<void> _onPollBreakDownRequested(
    LawPollBreakDownRequested event,
    Emitter<LawDetailState> emit,
  ) async {
    emit(state.copyWith(pollBreakdownStatus: LawPollBreakdownStatus.loading));

    final result = await _getPollBreakdown(event.pollId);
    result.fold(
      (failure) => emit(state.copyWith(pollBreakdownStatus: LawPollBreakdownStatus.failure)),
      (breakdown) => emit(state.copyWith(
        pollBreakdownStatus: LawPollBreakdownStatus.success,
        pollBreakdown: breakdown,
      )),
    );
  }

  Future<void> _onRelatedBillsRequested(
    LawRelatedBillsRequested event,
    Emitter<LawDetailState> emit,
  ) async {
    if (event.billIds.isEmpty) return;
    emit(state.copyWith(relatedBillsStatus: LawRelatedBillsStatus.loading));

    final result = await _getRelatedBills(event.billIds);
    result.fold(
      (failure) => emit(state.copyWith(relatedBillsStatus: LawRelatedBillsStatus.failure)),
      (bills) => emit(state.copyWith(
        relatedBillsStatus: LawRelatedBillsStatus.success,
        relatedBills: bills,
      )),
    );
  }
}
