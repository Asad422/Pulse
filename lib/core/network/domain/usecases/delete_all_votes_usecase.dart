import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../repositories/polls_repository.dart';

@lazySingleton
class DeleteAllVotesUseCase {
  final PollsRepository repository;
  const DeleteAllVotesUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.deleteAllVotes();
  }
}
