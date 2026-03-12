import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import 'package:pulse/features/bills/domain/usecases/cancel_vote_for_bill_usecase.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bills_query.dart';
import '../../domain/entities/bill_poll_query.dart';
import '../../domain/usecases/get_bills_usecase.dart';
import '../../domain/usecases/vote_for_bill_usecase.dart';

part 'bills_event.dart';
part 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final GetBillsUseCase _getBills;
  final VoteForBillUseCase _voteForBill;
  final CancelVoteForBillUseCase _cancelVoteForBill;

  BillsBloc(this._getBills, this._voteForBill, this._cancelVoteForBill)
      : super(const BillsState.initial()) {
    on<BillsRequested>(_onRequested);
    on<BillsLoadMoreRequested>(_onLoadMore);
    on<BillsVoteSubmitted>(_onVoteSubmitted);
    on<BillsCancelVoteSubmitted>(_onCancelVoteSubmitted);
  }

  static const _pageSize = 20;

  Future<void> _onRequested(
    BillsRequested event,
    Emitter<BillsState> emit,
  ) async {
    emit(state.copyWith(status: BillsStatus.loading, clearFailure: true, hasReachedEnd: false));

    final result = await _getBills(event.query);
    result.fold(
      (failure) => emit(state.copyWith(status: BillsStatus.failure, failure: failure)),
      (bills) => emit(state.copyWith(
        status: BillsStatus.success,
        items: bills,
        query: event.query,
        hasReachedEnd: bills.length < event.query.limit,
      )),
    );
  }

  Future<void> _onLoadMore(
    BillsLoadMoreRequested event,
    Emitter<BillsState> emit,
  ) async {
    if (state.hasReachedEnd ||
        state.status == BillsStatus.loadingMore ||
        state.isVoting) return;

    emit(state.copyWith(status: BillsStatus.loadingMore, clearFailure: true));

    final nextQuery = state.query?.copyWith(skip: state.items.length, limit: _pageSize)
        ?? BillsQuery(skip: state.items.length, limit: _pageSize);

    final result = await _getBills(nextQuery);
    result.fold(
      (failure) => emit(state.copyWith(status: BillsStatus.failure, failure: failure)),
      (bills) {
        if (bills.isEmpty) {
          emit(state.copyWith(hasReachedEnd: true, status: BillsStatus.success));
        } else {
          emit(state.copyWith(
            status: BillsStatus.success,
            items: [...state.items, ...bills],
            hasReachedEnd: bills.length < _pageSize,
          ));
        }
      },
    );
  }

  Future<void> _onVoteSubmitted(
    BillsVoteSubmitted event,
    Emitter<BillsState> emit,
  ) async {
    emit(state.copyWith(
      isVoting: true,
      votingPollId: event.pollId,
      votingChoice: event.choice,
      clearFailure: true,
    ));

    final result = await _voteForBill(
      BillPollQuery(pollId: event.pollId, choice: event.choice),
    );

    await result.fold(
      (failure) async => emit(state.copyWith(
        failure: failure,
        isVoting: false,
        votingPollId: null,
        votingChoice: null,
      )),
      (_) async => _refreshAfterVote(emit),
    );
  }

  Future<void> _onCancelVoteSubmitted(
    BillsCancelVoteSubmitted event,
    Emitter<BillsState> emit,
  ) async {
    emit(state.copyWith(
      isVoting: true,
      votingPollId: event.pollId,
      votingChoice: event.choice,
      clearFailure: true,
    ));

    final result = await _cancelVoteForBill(event.voteId);

    await result.fold(
      (failure) async => emit(state.copyWith(
        failure: failure,
        isVoting: false,
        votingPollId: null,
        votingChoice: null,
      )),
      (_) async => _refreshAfterVote(emit),
    );
  }

  Future<void> _refreshAfterVote(Emitter<BillsState> emit) async {
    final currentQuery = state.query;
    if (currentQuery != null) {
      final totalLoaded = state.items.length;
      final refreshQuery = currentQuery.copyWith(
        skip: 0,
        limit: totalLoaded > 0 ? totalLoaded : _pageSize,
      );
      final refreshResult = await _getBills(refreshQuery);
      refreshResult.fold(
        (failure) => emit(state.copyWith(
          failure: failure,
          isVoting: false,
          votingPollId: null,
          votingChoice: null,
        )),
        (bills) => emit(state.copyWith(
          status: BillsStatus.success,
          items: bills,
          query: currentQuery,
          hasReachedEnd: state.hasReachedEnd,
          isVoting: false,
          votingPollId: null,
          votingChoice: null,
        )),
      );
    } else {
      emit(state.copyWith(
        isVoting: false,
        votingPollId: null,
        votingChoice: null,
      ));
    }
  }
}
