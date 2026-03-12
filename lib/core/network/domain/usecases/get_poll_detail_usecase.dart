import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/poll.dart';
import '../repositories/polls_repository.dart';

@lazySingleton
class GetPollDetailUseCase {
  final PollsRepository repository;
  const GetPollDetailUseCase(this.repository);

  Future<Either<Failure, Poll>> call(int pollId) {
    return repository.getPollById(pollId);
  }
}
