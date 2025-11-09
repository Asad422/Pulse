import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_amendment.dart';
import '../../domain/entities/bill_sponsor.dart';
import '../../domain/entities/bill_text.dart';
import '../../domain/entities/bill_crs_report.dart';

import '../../domain/usecases/get_bill_usecase.dart';
import '../../domain/usecases/get_bill_amendments_usecase.dart';
import '../../domain/usecases/get_bill_sponsors_usecase.dart';
import '../../domain/usecases/get_bill_text_usecase.dart';
import '../../domain/usecases/get_bill_crs_reports_usecase.dart';

part 'bill_detail_event.dart';
part 'bill_detail_state.dart';

class BillDetailBloc extends Bloc<BillDetailEvent, BillDetailState> {
  final GetBillUseCase _getBill;
  final GetBillAmendmentsUseCase _getAmendments;
  final GetBillSponsorsUseCase _getSponsors;
  final GetBillTextUseCase _getText;
  final GetBillCrsReportsUseCase _getCrsReports;

  BillDetailBloc(
      this._getBill,
      this._getAmendments,
      this._getSponsors,
      this._getText,
      this._getCrsReports,
      ) : super(const BillDetailState.initial()) {
    on<BillDetailRequested>(_onRequested);
    on<BillAmendmentsRequested>(_onAmendmentsRequested);
    on<BillSponsorsRequested>(_onSponsorsRequested);
    on<BillTextRequested>(_onTextRequested);
    on<BillCrsReportsRequested>(_onCrsReportsRequested);
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

  Future<void> _onAmendmentsRequested(
      BillAmendmentsRequested event,
      Emitter<BillDetailState> emit,
      ) async {
    emit(state.copyWith(status: BillDetailStatus.loading));
    try {
      final amendments = await _getAmendments(event.billId);
      emit(state.copyWith(
        status: BillDetailStatus.success,
        amendments: amendments,
      ));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(
        status: BillDetailStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSponsorsRequested(
      BillSponsorsRequested event,
      Emitter<BillDetailState> emit,
      ) async {
    emit(state.copyWith(status: BillDetailStatus.loading));
    try {
      final sponsors = await _getSponsors(event.billId);
      emit(state.copyWith(
        status: BillDetailStatus.success,
        sponsors: sponsors,
      ));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(
        status: BillDetailStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onTextRequested(
      BillTextRequested event,
      Emitter<BillDetailState> emit,
      ) async {
    emit(state.copyWith(status: BillDetailStatus.loading));
    try {
      final text = await _getText(event.textId);
      emit(state.copyWith(
        status: BillDetailStatus.success,
        billText: text,
      ));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(
        status: BillDetailStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCrsReportsRequested(
      BillCrsReportsRequested event,
      Emitter<BillDetailState> emit,
      ) async {
    emit(state.copyWith(status: BillDetailStatus.loading));
    try {
      final reports = await _getCrsReports(event.billId);
      emit(state.copyWith(
        status: BillDetailStatus.success,
        crsReports: reports,
      ));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(
        status: BillDetailStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
