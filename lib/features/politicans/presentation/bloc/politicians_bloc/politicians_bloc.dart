import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/politician.dart';
import '../../../domain/repositories/politicians_repository.dart';
import '../../../domain/usecases/get_politicians_usecase.dart';

part 'politicians_event.dart';
part 'politicians_state.dart';

class PoliticiansBloc extends Bloc<PoliticiansEvent, PoliticiansState> {
  PoliticiansBloc(this._useCase) : super(const PoliticiansState.initial()) {
    on<PoliticiansLoadRequested>(_onLoad);
    on<PoliticiansLoadMoreRequested>(_onLoadMore);
  }

  final GetPoliticiansUseCase _useCase;

  static const _pageSize = 20;

  Future<void> _onLoad(
      PoliticiansLoadRequested event,
      Emitter<PoliticiansState> emit,
      ) async {
    emit(state.copyWith(status: PoliticiansStatus.loading, error: null, hasReachedEnd: false));
    try {
      final list = await _useCase(event.query);
      emit(state.copyWith(
        status: PoliticiansStatus.success,
        items: list,
        hasReachedEnd: list.length < event.query.limit,
      ));
    } catch (e) {
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
      final query = PoliticiansQuery(skip: nextSkip, limit: _pageSize);

      final newList = await _useCase(query);

      if (newList.isEmpty) {
        emit(state.copyWith(hasReachedEnd: true, status: PoliticiansStatus.success));
      } else {
        emit(state.copyWith(
          status: PoliticiansStatus.success,
          items: List.of(state.items)..addAll(newList),
          hasReachedEnd: newList.length < _pageSize,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: PoliticiansStatus.failure, error: e.toString()));
    }
  }
}
