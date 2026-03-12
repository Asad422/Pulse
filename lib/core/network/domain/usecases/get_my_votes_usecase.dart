import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/vote.dart';
import '../repositories/polls_repository.dart';

@lazySingleton
class GetMyVotesUseCase {
  final PollsRepository repository;
  const GetMyVotesUseCase(this.repository);

  Future<Either<Failure, List<Vote>>> call() {
    return repository.getMyVotes();
  }
}
