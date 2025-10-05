part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  final UserStatus status;
  final User? user;
  final String? error;

  const UserState({
    required this.status,
    this.user,
    this.error,
  });

  const UserState.initial()
      : status = UserStatus.initial,
        user = null,
        error = null;

  UserState copyWith({
    UserStatus? status,
    User? user,
    String? error,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}
