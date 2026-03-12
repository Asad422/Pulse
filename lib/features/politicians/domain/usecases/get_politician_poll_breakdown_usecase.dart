import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';
import '../repositories/politicians_repository.dart';

@lazySingleton
class GetPoliticianPollBreakdownUseCase {
  final PoliticiansRepository _repo;
  GetPoliticianPollBreakdownUseCase(this._repo);

  Future<Either<Failure, PollBreakdown>> call(int pollId) {
    return _repo.getPollBreakDown(pollId);
  }
}
