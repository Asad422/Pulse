part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class UserRequested extends UserEvent {}

class UserUpdated extends UserEvent {
  final String login;
  final Profile profile;
  const UserUpdated({required this.login, required this.profile});
  @override
  List<Object?> get props => [login, profile];
}

class UserDeleted extends UserEvent {}

class UserInterestsRequested extends UserEvent {}

class UserSubjectsRequested extends UserEvent {}

