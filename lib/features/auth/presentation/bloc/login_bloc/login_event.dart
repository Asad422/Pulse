part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginOtpRequested extends LoginEvent {
  final String email;
  final String login;

  const LoginOtpRequested({required this.email, required this.login});

  @override
  List<Object?> get props => [email, login];
}

class LoginOtpVerified extends LoginEvent {
  final String email;
  final String code;

  const LoginOtpVerified({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}
