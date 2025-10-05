import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/politican_detail.dart' as dom;
import '../../../domain/usecases/get_politician_usecase.dart';

part 'politician_detail_event.dart';
part 'politician_detail_state.dart';

class PoliticianDetailBloc
    extends Bloc<PoliticianDetailEvent, PoliticianDetailState> {
  PoliticianDetailBloc(this._useCase)
      : super(const PoliticianDetailState.initial()) {
    on<PoliticianDetailRequested>(_onRequested);
  }

  final GetPoliticianUseCase _useCase;

  Future<void> _onRequested(
      PoliticianDetailRequested event,
      Emitter<PoliticianDetailState> emit,
      ) async {
    emit(state.copyWith(status: PoliticianDetailStatus.loading, error: null));

    try {
      final dom.PoliticianDetail detail =
      await _useCase(GetPoliticianParams(event.bioguideId));

      emit(state.copyWith(
        status: PoliticianDetailStatus.success,
        data: detail,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PoliticianDetailStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
