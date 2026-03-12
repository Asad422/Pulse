import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/vote.dart';
import '../repositories/polls_repository.dart';

@lazySingleton
class CreateVoteUseCase {
  final PollsRepository repository;
  const CreateVoteUseCase(this.repository);

  Future<Either<Failure, Vote>> call({
    required int pollId,
    required bool choice,
  }) {
    return repository.createVote(pollId: pollId, choice: choice);
  }
}
