import '../entities/vote.dart';
import '../repositories/polls_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateVoteUseCase {
  final PollsRepository repository;

  const CreateVoteUseCase(this.repository);

  Future<Vote> call({
    required int pollId,
    required bool choice,
  }) {
    return repository.createVote(
      pollId: pollId,
      choice: choice,
    );
  }
}
