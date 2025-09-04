import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/network/token_storage.dart';
import '../../../domain/entities/auth_tokens.dart';
import '../../../domain/usecases/login_usecase.dart';



part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final TokenStorage tokenStorage;

  LoginBloc({
    required this.loginUseCase,
    required this.tokenStorage,
  }) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());
    try {
      final tokens = await loginUseCase(
        login: event.login,
        password: event.password,
      );

      // сохраняем токены в хранилище (SecureStorage)
      await tokenStorage.writeTokens(tokens);

      emit(LoginSuccess(tokens));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
