import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class RequestOtpUseCase {
  final AuthRepository _repo;
  RequestOtpUseCase(this._repo);

  Future<Either<Failure, void>> call({required String email, required String login}) {
    return _repo.requestOtp(email: email, login: login);
  }
}
