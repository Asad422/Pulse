import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/delete_user_me_usecase.dart';
import '../../domain/usecases/get_user_me_usecase.dart';
import '../../domain/usecases/update_user_me_usecase.dart';


part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(
      this._getUserMe,
      this._updateUserMe,
      this._deleteUserMe,
      ) : super(const UserState.initial()) {
    on<UserRequested>(_onRequested);
    on<UserUpdated>(_onUpdated);
    on<UserDeleted>(_onDeleted);
  }

  final GetUserMeUseCase _getUserMe;
  final UpdateUserMeUseCase _updateUserMe;
  final DeleteUserMeUseCase _deleteUserMe;

  Future<void> _onRequested(UserRequested event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = await _getUserMe();
      emit(state.copyWith(status: UserStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onUpdated(UserUpdated event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = await _updateUserMe(
        login: event.login,
        profile: event.profile,
      );
      emit(state.copyWith(status: UserStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onDeleted(UserDeleted event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      await _deleteUserMe();
      emit(const UserState.initial());
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure, error: e.toString()));
    }
  }
}
