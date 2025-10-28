import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/domain/usecases/create_vote_usecase.dart';
import '../../../domain/entities/politician.dart';
import '../../../domain/entities/politicians_query.dart';
import '../../../domain/usecases/get_politicians_usecase.dart';

part 'politicians_event.dart';
part 'politicians_state.dart';

@injectable
class PoliticiansBloc extends Bloc<PoliticiansEvent, PoliticiansState> {
  final GetPoliticiansUseCase _getPoliticians;
  final CreateVoteUseCase _createVote;

  static const _pageSize = 20;

  PoliticiansBloc(this._getPoliticians, this._createVote)
      : super(const PoliticiansState.initial()) {
    on<PoliticiansLoadRequested>(
      _onLoad,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 350)).switchMap(mapper),
    );

    on<PoliticiansLoadMoreRequested>(_onLoadMore);
    on<PoliticianVoteSubmitted>(_onVoteSubmitted);
  }

  // === загрузка списка ===
  Future<void> _onLoad(
      PoliticiansLoadRequested event,
      Emitter<PoliticiansState> emit,
      ) async {
    emit(state.copyWith(
      status: PoliticiansStatus.loading,
      error: null,
      hasReachedEnd: false,
    ));

    try {
      final list = await _getPoliticians(event.query);

      emit(
        PoliticiansState(
          status: PoliticiansStatus.success,
          items: List.of(list),
          query: event.query,
          hasReachedEnd: list.length < event.query.limit,
        ),
      );
    } catch (e, st) {
      addError(e, st);
      emit(
        state.copyWith(
          status: PoliticiansStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  // === пагинация ===
  Future<void> _onLoadMore(
      PoliticiansLoadMoreRequested event,
      Emitter<PoliticiansState> emit,
      ) async {
    if (state.hasReachedEnd || state.status == PoliticiansStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: PoliticiansStatus.loadingMore));

    try {
      final nextSkip = state.items.length;
      final nextQuery =
          state.query?.copyWith(skip: nextSkip, limit: _pageSize) ??
              const PoliticiansQuery(skip: 0, limit: _pageSize);

      final newList = await _getPoliticians(nextQuery);

      if (newList.isEmpty) {
        emit(
          state.copyWith(
            hasReachedEnd: true,
            status: PoliticiansStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PoliticiansStatus.success,
            items: [...state.items, ...newList],
            hasReachedEnd: newList.length < _pageSize,
          ),
        );
      }
    } catch (e, st) {
      addError(e, st);
      emit(
        state.copyWith(
          status: PoliticiansStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  // === голосование ===
  Future<void> _onVoteSubmitted(
      PoliticianVoteSubmitted event,
      Emitter<PoliticiansState> emit,
      ) async {
    try {
      final vote = await _createVote(
        pollId: event.pollId,
        choice: event.choice,
      );

      emit(
        state.copyWith(
          status: PoliticiansStatus.success,
          voteJustSent: _VoteInfo(
            pollId: vote.pollId,
            choice: vote.choice,
          ),
        ),
      );
    } on DioException catch (e, st) {
      // ✅ обрабатываем 409 (повторное голосование)
      if (e.response?.statusCode == 409) {
        emit(
          state.copyWith(
            status: PoliticiansStatus.success,
            voteJustSent: const _VoteInfo(pollId: -1, choice: false),
            error: 'already_voted', // флаг для UI
          ),
        );
      } else {
        addError(e, st);
        emit(
          state.copyWith(
            status: PoliticiansStatus.failure,
            error: e.message,
          ),
        );
      }
    } catch (e, st) {
      addError(e, st);
      emit(
        state.copyWith(
          status: PoliticiansStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

}
