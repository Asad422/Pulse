import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/domain/usecases/create_vote_usecase.dart';
import '../../../../../core/network/domain/usecases/delete_vote_usecase.dart';
import '../../../domain/entities/politician.dart';
import '../../../domain/entities/politicians_query.dart';
import '../../../domain/usecases/get_politicians_usecase.dart';

part 'politicians_event.dart';
part 'politicians_state.dart';

@injectable
class PoliticiansBloc extends Bloc<PoliticiansEvent, PoliticiansState> {
  final GetPoliticiansUseCase _getPoliticians;
  final CreateVoteUseCase _createVote;
  final DeleteVoteUseCase _deleteVote;

  static const _pageSize = 20;

  PoliticiansBloc(this._getPoliticians, this._createVote, this._deleteVote)
      : super(const PoliticiansState.initial()) {
    on<PoliticiansLoadRequested>(
      _onLoad,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 350)).switchMap(mapper),
    );
    on<PoliticiansLoadMoreRequested>(_onLoadMore);
    on<PoliticianVoteSubmitted>(_onVoteSubmitted);
    on<PoliticianCancelVoteSubmitted>(_onCancelVoteSubmitted);
  }

  Future<void> _onLoad(
    PoliticiansLoadRequested event,
    Emitter<PoliticiansState> emit,
  ) async {
    emit(state.copyWith(status: PoliticiansStatus.loading, clearFailure: true, hasReachedEnd: false));

    final result = await _getPoliticians(event.query);
    result.fold(
      (failure) => emit(state.copyWith(status: PoliticiansStatus.failure, failure: failure)),
      (list) => emit(PoliticiansState(
        status: PoliticiansStatus.success,
        items: List.of(list),
        query: event.query,
        hasReachedEnd: list.length < event.query.limit,
      )),
    );
  }

  Future<void> _onLoadMore(
    PoliticiansLoadMoreRequested event,
    Emitter<PoliticiansState> emit,
  ) async {
    if (state.hasReachedEnd ||
        state.status == PoliticiansStatus.loadingMore ||
        state.isVoting) return;

    emit(state.copyWith(status: PoliticiansStatus.loadingMore, clearFailure: true));

    final nextSkip = state.items.length;
    final nextQuery = state.query?.copyWith(skip: nextSkip, limit: _pageSize) ??
        const PoliticiansQuery(skip: 0, limit: _pageSize);

    final result = await _getPoliticians(nextQuery);
    result.fold(
      (failure) => emit(state.copyWith(status: PoliticiansStatus.failure, failure: failure)),
      (newList) {
        if (newList.isEmpty) {
          emit(state.copyWith(hasReachedEnd: true, status: PoliticiansStatus.success));
        } else {
          emit(state.copyWith(
            status: PoliticiansStatus.success,
            items: [...state.items, ...newList],
            hasReachedEnd: newList.length < _pageSize,
          ));
        }
      },
    );
  }

  Future<void> _onVoteSubmitted(
    PoliticianVoteSubmitted event,
    Emitter<PoliticiansState> emit,
  ) async {
    emit(state.copyWith(
      isVoting: true,
      votingPollId: event.pollId,
      votingChoice: event.choice,
      clearFailure: true,
    ));

    final voteResult = await _createVote(pollId: event.pollId, choice: event.choice);

    await voteResult.fold(
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
    PoliticianCancelVoteSubmitted event,
    Emitter<PoliticiansState> emit,
  ) async {
    emit(state.copyWith(
      isVoting: true,
      votingPollId: event.pollId,
      votingChoice: event.choice,
      clearFailure: true,
    ));

    final cancelResult = await _deleteVote(event.voteId);

    await cancelResult.fold(
      (failure) async => emit(state.copyWith(
        failure: failure,
        isVoting: false,
        votingPollId: null,
        votingChoice: null,
      )),
      (_) async => _refreshAfterVote(emit),
    );
  }

  Future<void> _refreshAfterVote(Emitter<PoliticiansState> emit) async {
    final currentQuery = state.query;
    if (currentQuery != null) {
      final totalLoaded = state.items.length;
      final refreshQuery = currentQuery.copyWith(
        skip: 0,
        limit: totalLoaded > 0 ? totalLoaded : _pageSize,
      );
      final refreshResult = await _getPoliticians(refreshQuery);
      refreshResult.fold(
        (failure) => emit(state.copyWith(
          failure: failure,
          isVoting: false,
          votingPollId: null,
          votingChoice: null,
        )),
        (politicians) => emit(state.copyWith(
          status: PoliticiansStatus.success,
          items: politicians,
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
