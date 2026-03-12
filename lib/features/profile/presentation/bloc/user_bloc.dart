import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import 'package:pulse/core/network/domain/entities/vote.dart';
import 'package:pulse/features/profile/domain/entities/age_category.dart';
import 'package:pulse/features/profile/domain/entities/sex_category.dart';
import 'package:pulse/features/profile/domain/usecases/add_user_interest_usecase.dart';
import 'package:pulse/features/profile/domain/usecases/get_profile_enums_usecase.dart';
import 'package:pulse/features/profile/domain/usecases/get_vote_history_usecase.dart';
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
    this._getSubjects,
    this._addUserInterest,
    this._getVoteHistory,
    this._getProfileEnums,
  ) : super(const UserState.initial()) {
    on<UserRequested>(_onRequested);
    on<UserUpdated>(_onUpdated);
    on<UserDeleted>(_onDeleted);
    on<UserInterestsRequested>(_onInterestsRequested);
    on<UserSubjectsRequested>(_onSubjectsRequested);
    on<UserVoteHistoryRequested>(_onVoteHistoryRequested);
    on<UserAddInterestRequested>(_onAddInterestRequested);
    on<UserProfileEnumsRequested>(_onProfileEnumsRequested);
  }

  final GetUserMeUseCase _getUserMe;
  final UpdateUserMeUseCase _updateUserMe;
  final DeleteUserMeUseCase _deleteUserMe;
  final GetUserInterestsUseCase _getUserInterests;
  final GetVoteHistoryUsecase _getVoteHistory;
  final GetSubjectsUseCase _getSubjects;
  final AddUserInterestUseCase _addUserInterest;
  final GetProfileEnumsUseCase _getProfileEnums;

  Future<void> _onRequested(UserRequested event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading, clearFailure: true));
    final result = await _getUserMe();
    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, failure: failure)),
      (user) => emit(state.copyWith(status: UserStatus.success, user: user)),
    );
  }

  Future<void> _onUpdated(UserUpdated event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading, clearFailure: true));
    final result = await _updateUserMe(login: event.login, profile: event.profile);
    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, failure: failure)),
      (user) => emit(state.copyWith(status: UserStatus.success, user: user)),
    );
  }

  Future<void> _onDeleted(UserDeleted event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading, clearFailure: true));
    final result = await _deleteUserMe();
    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, failure: failure)),
      (_) => emit(const UserState.initial()),
    );
  }

  Future<void> _onInterestsRequested(
    UserInterestsRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading, clearFailure: true));
    final result = await _getUserInterests();
    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, failure: failure)),
      (interests) => emit(state.copyWith(status: UserStatus.success, interests: interests)),
    );
  }

  Future<void> _onSubjectsRequested(
    UserSubjectsRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading, clearFailure: true));
    final result = await _getSubjects();
    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, failure: failure)),
      (subjects) => emit(state.copyWith(status: UserStatus.success, subjects: subjects)),
    );
  }

  Future<void> _onVoteHistoryRequested(
    UserVoteHistoryRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoadingVoteHistory: true, clearFailure: true));
    final result = await _getVoteHistory();
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserStatus.failure,
        failure: failure,
        isLoadingVoteHistory: false,
      )),
      (voteHistory) => emit(state.copyWith(
        status: UserStatus.success,
        voteHistory: voteHistory,
        isLoadingVoteHistory: false,
      )),
    );
  }

  Future<void> _onAddInterestRequested(
    UserAddInterestRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading, clearFailure: true));
    final result = await _addUserInterest(subjectId: event.subjectId);
    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, failure: failure)),
      (_) => emit(state.copyWith(status: UserStatus.success)),
    );
  }

  Future<void> _onProfileEnumsRequested(
    UserProfileEnumsRequested event,
    Emitter<UserState> emit,
  ) async {
    final result = await _getProfileEnums();
    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, failure: failure)),
      (enums) => emit(state.copyWith(
        status: UserStatus.success,
        ageCategories: enums.ageCategories,
        sexCategories: enums.sexCategories,
      )),
    );
  }
}
