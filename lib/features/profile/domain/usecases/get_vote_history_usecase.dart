import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/domain/entities/vote.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetVoteHistoryUsecase {
  final UserRepository _repo;
  GetVoteHistoryUsecase(this._repo);

  Future<Either<Failure, List<Vote>>> call() => _repo.getVoteHistory();
}
