import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_interest.dart';
import '../../domain/usecases/delete_user_me_usecase.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/usecases/get_user_me_usecase.dart';
import '../../domain/usecases/update_user_me_usecase.dart';
import '../../domain/usecases/get_user_interests_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(
      this._getUserMe,
      this._updateUserMe,
      this._deleteUserMe,
      this._getUserInterests,
      this._getSubjects, // 👈 новое

      ) : super(const UserState.initial()) {
    on<UserRequested>(_onRequested);
    on<UserUpdated>(_onUpdated);
    on<UserDeleted>(_onDeleted);
    on<UserInterestsRequested>(_onInterestsRequested);
    on<UserSubjectsRequested>(_onSubjectsRequested); // 👈 новое

  }

  final GetUserMeUseCase _getUserMe;
  final UpdateUserMeUseCase _updateUserMe;
  final DeleteUserMeUseCase _deleteUserMe;
  final GetUserInterestsUseCase _getUserInterests;
  final GetSubjectsUseCase _getSubjects; // 👈 новое


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

  Future<void> _onInterestsRequested(
      UserInterestsRequested event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final interests = await _getUserInterests();
      emit(state.copyWith(status: UserStatus.success, interests: interests));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure, error: e.toString()));
    }
  }
  Future<void> _onSubjectsRequested(
      UserSubjectsRequested event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final subjects = await _getSubjects();
      emit(state.copyWith(status: UserStatus.success, subjects: subjects));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.failure, error: e.toString()));
    }
  }

}
