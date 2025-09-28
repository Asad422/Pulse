import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

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

  LoginBloc({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.tokenStorage,
  }) : super(LoginInitial()) {
    on<LoginOtpRequested>(_onOtpRequested);
    on<LoginOtpVerified>(_onOtpVerified);
  }

  Future<void> _onOtpRequested(
      LoginOtpRequested event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());
    try {
      await requestOtpUseCase(email: event.email, login: event.login);
      emit(LoginOtpRequestSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onOtpVerified(
      LoginOtpVerified event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());
    try {
      final tokens =
      await verifyOtpUseCase(email: event.email, code: event.code);

      // сохраняем токены (например SecureStorage)
      await tokenStorage.writeTokens(tokens);

      emit(LoginSuccess(tokens));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
