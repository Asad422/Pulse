import '../repositories/polls_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteVoteUseCase {
  final PollsRepository repository;

  const DeleteVoteUseCase(this.repository);

  Future<void> call(int voteId) {
    return repository.deleteVote(voteId);
  }
}
