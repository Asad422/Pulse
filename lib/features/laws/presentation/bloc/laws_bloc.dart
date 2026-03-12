import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import '../../domain/entities/law.dart';
import '../../domain/entities/laws_query.dart';
import '../../domain/entities/law_poll_query.dart';
import '../../domain/usecases/get_laws_usecase.dart';
import '../../domain/usecases/vote_for_law_usecase.dart';
import '../../domain/usecases/cancel_vote_for_law_usecase.dart';

part 'laws_event.dart';
part 'laws_state.dart';

class LawsBloc extends Bloc<LawsEvent, LawsState> {
  final GetLawsUseCase _getLaws;
  final VoteForLawUseCase _voteForLaw;
  final CancelVoteForLawUseCase _cancelVoteForLaw;

  static const _pageSize = 20;

  LawsBloc(this._getLaws, this._voteForLaw, this._cancelVoteForLaw)
      : super(const LawsState.initial()) {
    on<LawsRequested>(_onRequested);
    on<LawsLoadMoreRequested>(_onLoadMore);
    on<LawsVoteSubmitted>(_onVoteSubmitted);
    on<LawsCancelVoteSubmitted>(_onCancelVoteSubmitted);
  }

  Future<void> _onRequested(
    LawsRequested event,
    Emitter<LawsState> emit,
  ) async {
    emit(state.copyWith(status: LawsStatus.loading, clearFailure: true, hasReachedEnd: false));

    final result = await _getLaws(event.query);
    result.fold(
      (failure) => emit(state.copyWith(status: LawsStatus.failure, failure: failure)),
      (laws) => emit(state.copyWith(
        status: LawsStatus.success,
        items: List.of(laws),
        query: event.query,
        hasReachedEnd: laws.length < event.query.limit,
      )),
    );
  }

  Future<void> _onLoadMore(
    LawsLoadMoreRequested event,
    Emitter<LawsState> emit,
  ) async {
    if (state.hasReachedEnd ||
        state.status == LawsStatus.loadingMore ||
        state.isVoting) return;

    emit(state.copyWith(status: LawsStatus.loadingMore, clearFailure: true));

    final nextQuery = state.query?.copyWith(skip: state.items.length, limit: _pageSize)
        ?? LawsQuery(skip: state.items.length, limit: _pageSize);

    final result = await _getLaws(nextQuery);
    result.fold(
      (failure) => emit(state.copyWith(status: LawsStatus.failure, failure: failure)),
      (newList) {
        if (newList.isEmpty) {
          emit(state.copyWith(hasReachedEnd: true, status: LawsStatus.success));
        } else {
          emit(state.copyWith(
            status: LawsStatus.success,
            items: [...state.items, ...newList],
            hasReachedEnd: newList.length < _pageSize,
          ));
        }
      },
    );
  }

  Future<void> _onVoteSubmitted(
    LawsVoteSubmitted event,
    Emitter<LawsState> emit,
  ) async {
    emit(state.copyWith(
      isVoting: true,
      votingPollId: event.pollId,
      votingChoice: event.choice,
      clearFailure: true,
    ));

    final result = await _voteForLaw(
      LawPollQuery(pollId: event.pollId, choice: event.choice),
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
    LawsCancelVoteSubmitted event,
    Emitter<LawsState> emit,
  ) async {
    emit(state.copyWith(
      isVoting: true,
      votingPollId: event.pollId,
      votingChoice: event.choice,
      clearFailure: true,
    ));

    final result = await _cancelVoteForLaw(event.voteId);

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

  Future<void> _refreshAfterVote(Emitter<LawsState> emit) async {
    final currentQuery = state.query;
    if (currentQuery != null) {
      final totalLoaded = state.items.length;
      final refreshQuery = currentQuery.copyWith(
        skip: 0,
        limit: totalLoaded > 0 ? totalLoaded : _pageSize,
      );
      final refreshResult = await _getLaws(refreshQuery);
      refreshResult.fold(
        (failure) => emit(state.copyWith(
          failure: failure,
          isVoting: false,
          votingPollId: null,
          votingChoice: null,
        )),
        (laws) => emit(state.copyWith(
          status: LawsStatus.success,
          items: laws,
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
