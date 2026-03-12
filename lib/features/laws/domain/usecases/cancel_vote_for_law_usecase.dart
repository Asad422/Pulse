import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/features/laws/domain/repositories/laws_repository.dart';

@lazySingleton
class CancelVoteForLawUseCase {
  final LawsRepository _repo;
  CancelVoteForLawUseCase(this._repo);

  Future<Either<Failure, void>> call(int voteId) {
    return _repo.cancelVoteForLaw(voteId);
  }
}
