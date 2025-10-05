import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/politician.dart';
import '../../../domain/entities/politicians_query.dart';
import '../../../domain/usecases/get_politicians_usecase.dart';

part 'politicians_event.dart';
part 'politicians_state.dart';

class PoliticiansBloc extends Bloc<PoliticiansEvent, PoliticiansState> {
  final GetPoliticiansUseCase _useCase;
  static const _pageSize = 20;

  PoliticiansBloc(this._useCase) : super(const PoliticiansState.initial()) {
    on<PoliticiansLoadRequested>(
      _onLoad,
      transformer: (events, mapper) =>
          events.debounceTime(const Duration(milliseconds: 350)).switchMap(mapper),
    );
    on<PoliticiansLoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onLoad(
      PoliticiansLoadRequested event,
      Emitter<PoliticiansState> emit,
      ) async {
    emit(state.copyWith(status: PoliticiansStatus.loading, error: null, hasReachedEnd: false));

    try {
      final list = await _useCase(event.query);
      emit(PoliticiansState(
        status: PoliticiansStatus.success,
        items: List.of(list), // ✅ новая копия
        query: event.query,
        hasReachedEnd: list.length < event.query.limit,
      ));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(status: PoliticiansStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onLoadMore(
      PoliticiansLoadMoreRequested event,
      Emitter<PoliticiansState> emit,
      ) async {
    if (state.hasReachedEnd || state.status == PoliticiansStatus.loadingMore) return;

    emit(state.copyWith(status: PoliticiansStatus.loadingMore));

    try {
      final nextSkip = state.items.length;
      final nextQuery =
          state.query?.copyWith(skip: nextSkip, limit: _pageSize) ??
              const PoliticiansQuery(skip: 0, limit: _pageSize);

      final newList = await _useCase(nextQuery);

      if (newList.isEmpty) {
        emit(state.copyWith(hasReachedEnd: true, status: PoliticiansStatus.success));
      } else {
        emit(state.copyWith(
          status: PoliticiansStatus.success,
          // ✅ формируем новый список
          items: [...state.items, ...newList],
          hasReachedEnd: newList.length < _pageSize,
        ));
      }
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(status: PoliticiansStatus.failure, error: e.toString()));
    }
  }
}
