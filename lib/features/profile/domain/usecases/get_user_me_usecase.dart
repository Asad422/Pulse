import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUserMeUseCase {
  final UserRepository _repo;
  GetUserMeUseCase(this._repo);

  Future<Either<Failure, User>> call() => _repo.getUserMe();
}
