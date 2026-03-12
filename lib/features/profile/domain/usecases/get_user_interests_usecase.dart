import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/user_interest.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUserInterestsUseCase {
  final UserRepository _repo;
  GetUserInterestsUseCase(this._repo);

  Future<Either<Failure, List<UserInterest>>> call() => _repo.getUserInterests();
}
