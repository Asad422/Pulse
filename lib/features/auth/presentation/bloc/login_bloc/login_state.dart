part of 'login_bloc.dart';

abstract class LoginState extends AppState {
  const LoginState({super.failure});

  @override
  List<Object?> get props => [...super.props];
}

class LoginInitial extends LoginState {
  const LoginInitial() : super(failure: null);
}

class LoginLoading extends LoginState {
  const LoginLoading() : super(failure: null);
}

/// Успешный запрос OTP (код отправлен на email/логин)
class LoginOtpRequestSuccess extends LoginState {
  const LoginOtpRequestSuccess() : super(failure: null);
}

/// Успешная верификация OTP (получили токены)
class LoginSuccess extends LoginState {
  final AuthTokens tokens;
  const LoginSuccess(this.tokens) : super(failure: null);

  @override
  List<Object?> get props => [...super.props, tokens];
}

class LoginFailure extends LoginState {
  const LoginFailure(Failure failure) : super(failure: failure);

  String get message => failure!.message;

  @override
  List<Object?> get props => [...super.props];
}
