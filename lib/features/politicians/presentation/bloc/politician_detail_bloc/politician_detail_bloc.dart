import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import 'package:pulse/features/bills/domain/entities/bill.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';

import '../../../domain/entities/politican_detail.dart' as dom;
import '../../../domain/usecases/get_politician_usecase.dart';
import '../../../domain/usecases/get_sponsored_bills_usecase.dart';
import '../../../domain/usecases/get_cosponsored_bills_usecase.dart';
import '../../../domain/usecases/get_politician_poll_breakdown_usecase.dart';

part 'politician_detail_event.dart';
part 'politician_detail_state.dart';

class PoliticianDetailBloc
    extends Bloc<PoliticianDetailEvent, PoliticianDetailState> {
  PoliticianDetailBloc(
    this._getPolitician,
    this._getSponsoredBills,
    this._getCosponsoredBills,
    this._getPollBreakdown,
  ) : super(const PoliticianDetailState.initial()) {
    on<PoliticianDetailRequested>(_onRequested);
    on<PoliticianDetailRefreshRequested>(_onRefreshRequested);
    on<PoliticianSponsoredBillsRequested>(_onSponsoredBillsRequested);
    on<PoliticianCosponsoredBillsRequested>(_onCosponsoredBillsRequested);
    on<PoliticianPollBreakDownRequested>(_onPollBreakDownRequested);
  }

  final GetPoliticianUseCase _getPolitician;
  final GetSponsoredBillsUseCase _getSponsoredBills;
  final GetCosponsoredBillsUseCase _getCosponsoredBills;
  final GetPoliticianPollBreakdownUseCase _getPollBreakdown;

  Future<void> _onRequested(
    PoliticianDetailRequested event,
    Emitter<PoliticianDetailState> emit,
  ) async {
    emit(state.copyWith(status: PoliticianDetailStatus.loading, clearFailure: true));

    final result = await _getPolitician(event.bioguideId);
    result.fold(
      (failure) => emit(state.copyWith(status: PoliticianDetailStatus.failure, failure: failure)),
      (detail) => emit(state.copyWith(status: PoliticianDetailStatus.success, data: detail)),
    );
  }

  Future<void> _onRefreshRequested(
    PoliticianDetailRefreshRequested event,
    Emitter<PoliticianDetailState> emit,
  ) async {
    final result = await _getPolitician(event.bioguideId);
    result.fold(
      (failure) => addError(failure),
      (detail) => emit(state.copyWith(data: detail)),
    );
  }

  Future<void> _onSponsoredBillsRequested(
    PoliticianSponsoredBillsRequested event,
    Emitter<PoliticianDetailState> emit,
  ) async {
    emit(state.copyWith(sponsoredBillsStatus: BillsLoadStatus.loading));

    final result = await _getSponsoredBills(event.politicianId);
    result.fold(
      (failure) => emit(state.copyWith(sponsoredBillsStatus: BillsLoadStatus.failure)),
      (bills) => emit(state.copyWith(
        sponsoredBillsStatus: BillsLoadStatus.success,
        sponsoredBills: bills,
      )),
    );
  }

  Future<void> _onCosponsoredBillsRequested(
    PoliticianCosponsoredBillsRequested event,
    Emitter<PoliticianDetailState> emit,
  ) async {
    emit(state.copyWith(cosponsoredBillsStatus: BillsLoadStatus.loading));

    final result = await _getCosponsoredBills(event.politicianId);
    result.fold(
      (failure) => emit(state.copyWith(cosponsoredBillsStatus: BillsLoadStatus.failure)),
      (bills) => emit(state.copyWith(
        cosponsoredBillsStatus: BillsLoadStatus.success,
        cosponsoredBills: bills,
      )),
    );
  }

  Future<void> _onPollBreakDownRequested(
    PoliticianPollBreakDownRequested event,
    Emitter<PoliticianDetailState> emit,
  ) async {
    emit(state.copyWith(pollBreakdownStatus: PoliticianPollBreakdownStatus.loading));

    final result = await _getPollBreakdown(event.pollId);
    result.fold(
      (failure) => emit(state.copyWith(pollBreakdownStatus: PoliticianPollBreakdownStatus.failure)),
      (breakdown) => emit(state.copyWith(
        pollBreakdownStatus: PoliticianPollBreakdownStatus.success,
        pollBreakdown: breakdown,
      )),
    );
  }
}
