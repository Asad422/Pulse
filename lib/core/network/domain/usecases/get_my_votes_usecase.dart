import '../entities/vote.dart';
import '../repositories/polls_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetMyVotesUseCase {
  final PollsRepository repository;

  const GetMyVotesUseCase(this.repository);

  Future<List<Vote>> call() {
    return repository.getMyVotes();
  }
}
