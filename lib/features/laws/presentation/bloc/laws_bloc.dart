import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/law.dart';
import '../../domain/usecases/get_laws_usecase.dart';

part 'laws_event.dart';
part 'laws_state.dart';

class LawsBloc extends Bloc<LawsEvent, LawsState> {
  final GetLawsUseCase _getLaws;

  LawsBloc(this._getLaws) : super(const LawsState.initial()) {
    on<LawsRequested>(_onRequested);
  }

  Future<void> _onRequested(
      LawsRequested event,
      Emitter<LawsState> emit,
      ) async {
    emit(state.copyWith(status: LawsStatus.loading));
    try {
      final laws = await _getLaws(
        congress: event.congress,
        lawType: event.lawType,
        lawNumber: event.lawNumber,
        billId: event.billId,
      );
      emit(state.copyWith(status: LawsStatus.success, items: laws));
    } catch (e) {
      emit(state.copyWith(status: LawsStatus.failure, error: e.toString()));
    }
  }
}
