import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/law.dart';
import '../../domain/usecases/get_law_usecase.dart';

part 'law_detail_event.dart';
part 'law_detail_state.dart';

class LawDetailBloc extends Bloc<LawDetailEvent, LawDetailState> {
  final GetLawUseCase _getLaw;

  LawDetailBloc(this._getLaw) : super(const LawDetailState.initial()) {
    on<LawDetailRequested>(_onRequested);
  }

  Future<void> _onRequested(
      LawDetailRequested event,
      Emitter<LawDetailState> emit,
      ) async {
    emit(state.copyWith(status: LawDetailStatus.loading));
    try {
      final law = await _getLaw(event.lawId);
      emit(state.copyWith(status: LawDetailStatus.success, law: law));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(status: LawDetailStatus.failure, error: e.toString()));
    }
  }
}
