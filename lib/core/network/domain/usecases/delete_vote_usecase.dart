import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../repositories/polls_repository.dart';

@lazySingleton
class DeleteVoteUseCase {
  final PollsRepository repository;
  const DeleteVoteUseCase(this.repository);

  Future<Either<Failure, void>> call(int voteId) {
    return repository.deleteVote(voteId);
  }
}
