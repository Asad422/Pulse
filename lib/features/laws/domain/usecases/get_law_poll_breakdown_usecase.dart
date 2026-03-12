import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/bills/domain/entities/poll_breakdown.dart';
import '../repositories/laws_repository.dart';

@lazySingleton
class GetLawPollBreakdownUseCase {
  final LawsRepository _repo;
  GetLawPollBreakdownUseCase(this._repo);

  Future<Either<Failure, PollBreakdown>> call(int pollId) {
    return _repo.getPollBreakDown(pollId);
  }
}
