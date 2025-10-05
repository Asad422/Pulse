import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/law.dart';
import '../../domain/entities/laws_query.dart';
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
      // ✅ теперь вызываем use case с LawsQuery
      final laws = await _getLaws(event.query);
      emit(state.copyWith(status: LawsStatus.success, items: laws));
    } catch (e) {
      emit(state.copyWith(status: LawsStatus.failure, error: e.toString()));
    }
  }
}
