import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class RequestOtpUseCase {
  final AuthRepository _repo;
  RequestOtpUseCase(this._repo);

  Future<void> call({required String email, required String login}) {
    return _repo.requestOtp(email: email, login: login);
  }
}
