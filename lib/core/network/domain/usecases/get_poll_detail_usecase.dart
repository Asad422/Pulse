import '../entities/poll.dart';
import '../repositories/polls_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetPollDetailUseCase {
  final PollsRepository repository;

  const GetPollDetailUseCase(this.repository);

  Future<Poll> call(int pollId) {
    return repository.getPollById(pollId);
  }
}
