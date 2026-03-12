import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/poll.dart';
import '../repositories/polls_repository.dart';

@lazySingleton
class GetPollsUseCase {
  final PollsRepository repository;
  const GetPollsUseCase(this.repository);

  Future<Either<Failure, List<Poll>>> call({
    int skip = 0,
    int limit = 100,
    String? politicianId,
    int? billId,
  }) {
    return repository.getPolls(
      skip: skip,
      limit: limit,
      politicianId: politicianId,
      billId: billId,
    );
  }
}
