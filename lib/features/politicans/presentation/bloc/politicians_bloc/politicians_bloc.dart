import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/features/politicans/domain/repositories/politicians_repository.dart';
import 'package:pulse/features/politicans/domain/usecases/get_politicians_usecase.dart';

import '../../../domain/entities/politician.dart';

part 'politicians_event.dart';
part 'politicians_state.dart';

class PoliticiansBloc extends Bloc<PoliticiansEvent, PoliticiansState> {
  PoliticiansBloc(this._useCase) : super(const PoliticiansState.initial()) {
    on<PoliticiansLoadRequested>(_onLoad);
  }

  final GetPoliticiansUseCase _useCase;

  Future<void> _onLoad(
    PoliticiansLoadRequested event,
    Emitter<PoliticiansState> emit,
  ) async {
    emit(state.copyWith(status: PoliticiansStatus.loading, error: null));
    try {
      final list = await _useCase(event.query);
      emit(state.copyWith(status: PoliticiansStatus.success, items: list));
    } catch (e) {
      emit(state.copyWith(status: PoliticiansStatus.failure, error: e.toString()));
    }
  }
}
