import '../repositories/polls_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteAllVotesUseCase {
  final PollsRepository repository;

  const DeleteAllVotesUseCase(this.repository);

  Future<void> call() {
    return repository.deleteAllVotes();
  }
}
