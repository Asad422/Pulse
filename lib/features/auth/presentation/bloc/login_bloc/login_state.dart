part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

/// Успешный запрос OTP (код отправлен на email/логин)
class LoginOtpRequestSuccess extends LoginState {}

/// Успешная верификация OTP (получили токены)
class LoginSuccess extends LoginState {
  final AuthTokens tokens;
  const LoginSuccess(this.tokens);

  @override
  List<Object?> get props => [tokens];
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
