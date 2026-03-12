import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class DeleteUserMeUseCase {
  final UserRepository _repo;
  DeleteUserMeUseCase(this._repo);

  Future<Either<Failure, void>> call() => _repo.deleteUserMe();
}
