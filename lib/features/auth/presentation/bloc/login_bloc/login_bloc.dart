import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/state/app_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/auth/auth_notifier.dart';
import '../../../../../core/network/token_storage.dart';
import '../../../domain/entities/auth_tokens.dart';
import '../../../domain/usecases/request_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final TokenStorage tokenStorage;
  final AuthNotifier authNotifier;

  LoginBloc({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.tokenStorage,
    required this.authNotifier,
  }) : super(const LoginInitial()) {
    on<LoginOtpRequested>(_onOtpRequested);
    on<LoginOtpVerified>(_onOtpVerified);
  }

  Future<void> _onOtpRequested(
    LoginOtpRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await requestOtpUseCase(email: event.email, login: event.login);
    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (_) => emit(const LoginOtpRequestSuccess()),
    );
  }

  Future<void> _onOtpVerified(
    LoginOtpVerified event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await verifyOtpUseCase(email: event.email, code: event.code);
    await result.fold(
      (failure) async => emit(LoginFailure(failure)),
      (tokens) async {
        await tokenStorage.writeTokens(tokens);
        authNotifier.setLoggedIn();
        emit(LoginSuccess(tokens));
      },
    );
  }
}
