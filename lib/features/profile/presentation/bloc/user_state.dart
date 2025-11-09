part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  final UserStatus status;
  final User? user;
  final List<UserInterest> interests;
  final List<Subject> subjects; // 👈 новое поле
  final String? error;

  const UserState({
    required this.status,
    this.user,
    this.interests = const [],
    this.subjects = const [], // 👈 инициализация
    this.error,
  });

  const UserState.initial()
      : status = UserStatus.initial,
        user = null,
        interests = const [],
        subjects = const [], // 👈
        error = null;

  UserState copyWith({
    UserStatus? status,
    User? user,
    List<UserInterest>? interests,
    List<Subject>? subjects, // 👈
    String? error,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      interests: interests ?? this.interests,
      subjects: subjects ?? this.subjects, // 👈
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, user, interests, subjects, error];
}
